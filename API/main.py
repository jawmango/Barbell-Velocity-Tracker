from flask import Flask, request, jsonify, send_from_directory
from supervision import ColorPalette
from ultralytics import YOLO
import supervision as sv
import os, csv, math, cv2
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import joblib


app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///results.db'
db = SQLAlchemy(app)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

RESULT_FOLDER = 'results'
os.makedirs(RESULT_FOLDER, exist_ok=True)
app.config['RESULT_FOLDER'] = RESULT_FOLDER

class Exercise(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    exercise = db.Column(db.String(255), nullable=False)
    load = db.Column(db.Float)
    date_added = db.Column(db.DateTime, default=datetime.now())
    filename = db.Column(db.String(255), nullable=False)
    intensity = db.Column(db.String(255))

    def __repr__(self):
        return f'<Exercise {self.exercise} at {self.date_added}>'

class Path(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    exercise_id = db.Column(db.Integer, db.ForeignKey('exercise.id'), nullable=False)
    repetition = db.Column(db.Integer, nullable=False)
    x_pos = db.Column(db.Float, nullable=False)
    y_pos = db.Column(db.Float, nullable=False)
    frame = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f'<Path {self.path} at {self.repetition}>'

class Repetition(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    exercise_id = db.Column(db.Integer, db.ForeignKey('exercise.id'), nullable=False)
    repetition = db.Column(db.Integer, nullable=False)
    velocity_c = db.Column(db.Float, nullable=False)
    velocity_e = db.Column(db.Float, nullable=False)
    mean_velocity = db.Column(db.Float, nullable=False)
    velocity_loss = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f'<Repetition {self.repetition} at {self.exercise_id}>'


@app.route('/')
def barbell():
    return "Barbell"

@app.route('/results', methods=['GET'])
def result_list():
    exercise = db.session.execute(db.select(Exercise).order_by(Exercise.id.desc())).scalars().all()
    results = {
        "exercise": [{"id": i.id, "exercise": i.exercise, "load": i.load, "date_added": i.date_added.isoformat(" ", "minutes"), "filename": i.filename, "intensity": i.intensity} for i in exercise]}
    return jsonify(results), 200

@app.route('/repetition', methods=['GET'])
def repetition_list():
    exercise_id = request.args.get('id', type=int)
    repetition = db.session.execute(db.select(Repetition).filter_by(exercise_id=exercise_id)).scalars().all()
    results = {
        "repetition": [{"id": i.id, "exercise_id": i.exercise_id, "repetition": i.repetition, "velocity_c": i.velocity_c, "velocity_e": i.velocity_e, "mean_velocity": i.mean_velocity, "velocity_loss": i.velocity_loss} for i in repetition]
    }
    return jsonify(results), 200

@app.route('/path', methods=['GET'])
def path_list():
    exercise_id = request.args.get('id', type=int)
    path = db.session.execute(db.select(Path).filter_by(exercise_id=exercise_id)).scalars().all()
    results = {
        "path": [{"id": i.id, "exercise_id": i.exercise_id, "repetition": i.repetition, "x_pos": i.x_pos, "y_pos": i.y_pos, "frame": i.frame} for i in path]
    }
    return jsonify(results), 200

@app.route('/remove', methods=['DELETE'])
def remove():
    exercise_id = request.args.get('id', type=int)
    filename = request.args.get('filename', type=str)

    if filename:
        uploaded_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        csv_path = os.path.join(app.config['RESULT_FOLDER'], filename + '_summary.csv')
        velocity_path = os.path.join(app.config['RESULT_FOLDER'], filename + '_velocity.csv')
        image_path = os.path.join(app.config['RESULT_FOLDER'], filename + '_summary.png')
        output_path = os.path.join(app.config['RESULT_FOLDER'], filename + '_output.mp4')

    if os.path.exists(uploaded_path) and os.path.exists(csv_path) and os.path.exists(image_path) and os.path.exists(output_path) :
        os.remove(uploaded_path)
        os.remove(csv_path)
        os.remove(velocity_path)
        os.remove(image_path)
        os.remove(output_path)

    with db.session.begin():
        db.session.execute(db.delete(Repetition).filter_by(exercise_id=exercise_id))
        db.session.execute(db.delete(Exercise).filter_by(id=exercise_id))
        db.session.execute(db.delete(Path).filter_by(exercise_id=exercise_id))

    return jsonify({'message': 'Entry Successfully Deleted'}), 200

@app.route('/upload', methods=['POST'])
def upload_video():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file:
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filepath)
        return jsonify({'message': 'File uploaded successfully', 'filename': file.filename}), 200


@app.route('/video/<filename>/summary', methods=['GET'])
def get_summary(filename):
    csvpath = os.path.join(app.config['RESULT_FOLDER'], filename+'_summary.csv')
    velocity_path = os.path.join(app.config['RESULT_FOLDER'], filename + '_velocity.csv')
    df = pd.read_csv(csvpath)
    df_velocity = pd.read_csv(velocity_path)
    image_path = os.path.join(app.config['RESULT_FOLDER'], filename+'_summary.png')

    if os.path.exists(image_path):

        return send_from_directory(app.config['RESULT_FOLDER'], filename+'_summary.png')

    import matplotlib
    matplotlib.use('Agg')

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(6.2, 13.4), dpi=100)

    sns.scatterplot(
        x='Center_X', y='Center_Y',
        hue='Repetition', palette='viridis',
        data=df, s=40, alpha=0.6, ax=ax1
    )
    ax1.set_title('Barbell Path')
    ax1.set_xlabel('Center X')
    ax1.set_ylabel('Center Y')
    ax1.grid(True)
    ax1.legend(title='Rep Number', loc='best', fontsize='small')

    df_avg_speed = df_velocity.groupby('Repetition').agg({
        'Velocity': 'mean',
        'Velocity_e': 'mean'
    }).reset_index()

    sns.lineplot(x='Repetition', y='Velocity', data=df_avg_speed, marker='o', label='Average Concentric Speed', color='blue')


    sns.lineplot(x='Repetition', y='Velocity_e', data=df_avg_speed, marker='o', label='Average Eccentric Speed', color='red')

    plt.title('Average Speed per Repetition')
    plt.xlabel('Repetition')
    plt.ylabel('Average Speed (m/s)')
    plt.legend()
    plt.grid(True)

    plt.tight_layout()
    plt.savefig(image_path)

    return send_from_directory(app.config['RESULT_FOLDER'], filename+'_summary.png')




@app.route('/video/<filename>', methods=['GET'])
def get_video(filename):
    exercise_name = request.args.get('exercise', 'unknown')
    barbell_size = request.args.get('barbell', 'unknown')
    load = int(request.args.get('load', 'unknown'))
    csv_path = os.path.join(app.config['RESULT_FOLDER'], filename+'_summary.csv')
    velocity_path = os.path.join(app.config['RESULT_FOLDER'], filename + '_velocity.csv')
    output_path = os.path.join(app.config['RESULT_FOLDER'], filename+'_output.mp4')

    exercise_table = Exercise(exercise=exercise_name, load=load, filename=filename)
    db.session.add(exercise_table)
    db.session.flush()

    if os.path.exists(output_path):

        return send_from_directory(app.config['RESULT_FOLDER'], filename+'_output.mp4')
    else:

        model = YOLO('barbell300.pt')
        feedback = joblib.load('feedback_model_2.pkl')

        if barbell_size == 'Standard':
            real_life_barbell_diameter_meters = 0.025
        else:
            real_life_barbell_diameter_meters = 0.05

        tracker = sv.ByteTrack()
        bounding_box_annotator = sv.BoxAnnotator(color=sv.ColorPalette.from_hex(['#009684']))
        label_annotator = sv.LabelAnnotator(color=sv.ColorPalette.from_hex(['#009684']))
        trace_annotator = sv.TraceAnnotator(color=sv.ColorPalette.from_hex(['#009684']))
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)

        cap = cv2.VideoCapture(filepath)
        w, h, fps = (int(cap.get(x)) for x in (cv2.CAP_PROP_FRAME_WIDTH, cv2.CAP_PROP_FRAME_HEIGHT, cv2.CAP_PROP_FPS))

        out = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))

        barbell_class_id = 0
        barbell_tracker_id = 1

        barbell_positions = []
        prev_positions = {}


        barbell_diameter_pixels = None

        frame_number = 0
        rep_count = 0
        in_rep = False
        threshold = None

        speed_per_rep = float(0)
        count = 0
        avg_per_rep = float(0)
        avg_c = float(0)
        vel_rep = [0]
        vel_loss = 0
        vel_list = []
        speed_per_rep_e = float(0)
        count_e = 0
        avg_per_rep_e = float(0)
        avg_e = float(0)
        vel_rep_e = [0]

        while cap.isOpened():
            ret, img = cap.read()
            if not ret:
                break

            results = model.predict(img, device="mps")
            detections = sv.Detections.from_ultralytics(results[0])
            detections = detections[detections.confidence > 0.3]

            detections = tracker.update_with_detections(detections)

            final_tracker_ids = []
            for i, class_id in enumerate(detections.class_id):
                if class_id == barbell_class_id:
                    final_tracker_ids.append(barbell_tracker_id)
                else:
                    final_tracker_ids.append(detections.tracker_id[i])

            detections.tracker_id = final_tracker_ids

            labels = [
                f"{model.model.names[class_id]} ID:{tracker_id}"
                for class_id, tracker_id
                in zip(detections.class_id, detections.tracker_id)
            ]

            annotated_frame = bounding_box_annotator.annotate(
                scene=img,
                detections=detections
            )
            annotated_frame = label_annotator.annotate(
                scene=annotated_frame, detections=detections, labels=labels
            )
            annotated_frame = trace_annotator.annotate(
                annotated_frame, detections=detections
            )

            for i, class_id in enumerate(detections.class_id):
                if class_id == barbell_class_id:
                    tracker_id = detections.tracker_id[i]
                    x1, y1, x2, y2 = detections.xyxy[i]
                    center_x = (x1 + x2) / 2
                    center_y = (y1 + y2) / 2
                    speed_e = float(0)
                    speed_c = float(0)
                    new_rep = False

                    if barbell_diameter_pixels is None:
                        barbell_diameter_pixels = x2 - x1 # box width
                        print(f"Estimated barbell diameter in pixels: {barbell_diameter_pixels}")

                    scale_factor = real_life_barbell_diameter_meters / barbell_diameter_pixels #reference object

                    barbell_positions.append((frame_number, center_x, center_y))
                    speed_text = "Speed: N/A"
                    speed_text_e = "Speed: N/A"

                    if tracker_id in prev_positions:
                        prev_x, prev_y, prev_frame = prev_positions[tracker_id]

                        if threshold is None:
                            threshold = center_y*1.1

                        if center_y < threshold and in_rep:
                            rep_count += 1
                            new_rep = True
                            in_rep = False

                        elif center_y > threshold and not in_rep:
                            in_rep = True

                        elif center_y > threshold and in_rep:
                            if center_y < prev_y:
                                distance_pixels = math.sqrt((center_x - prev_x)**2 + (center_y - prev_y)**2)

                                distance_meters = distance_pixels * scale_factor

                                speed_c = distance_meters * fps

                                speed_text = f"Velocity: {speed_c:.2f} m/s"

                            if center_y > prev_y:
                                    distance_pixels = math.sqrt((center_x - prev_x)**2 + (center_y - prev_y)**2)

                                    distance_meters = distance_pixels * scale_factor

                                    speed_e = distance_meters * fps

                                    speed_text_e = f"Velocity: {speed_e:.2f} m/s"
                            barbell_positions.append((frame_number, center_x, center_y, speed_c, speed_e, rep_count+1))
                            b_path = Path(
                                exercise_id = exercise_table.id,
                                repetition = rep_count+1,
                                x_pos = center_x,
                                y_pos = center_y,
                                frame = frame_number,
                            )
                            db.session.add(b_path)

                        if new_rep:
                            vel_rep.append(avg_per_rep)
                            vel_rep_e.append(avg_per_rep_e)
                            avg_c = sum(vel_rep) / (len(vel_rep) - 1)
                            if vel_rep[1] != 0:
                                vel_loss = ((vel_rep[1] - vel_rep[-1]) / vel_rep[1]) * 100
                            if vel_loss < 0:
                                vel_loss = 0
                            speed_per_rep = 0
                            speed_per_rep_e = 0
                            count = 0
                            count_e = 0
                            speed_per_rep += speed_c
                            speed_per_rep_e += speed_e
                            count += 1
                            count_e += 1
                            vel_list.append([rep_count, vel_rep[-1], vel_rep_e[-1], vel_loss, avg_c])
                            rep = Repetition(
                            exercise_id = exercise_table.id,
                            repetition = rep_count,
                            velocity_c = round(vel_rep[-1], 2),
                            velocity_e = round(vel_rep_e[-1], 2),
                            mean_velocity = round (avg_c, 2),
                            velocity_loss = round (vel_loss, 2),
                            )
                            db.session.add(rep)

                        else:
                            if speed_c != 0 and speed_c >= 0.05 and speed_c <= 1.3:
                                speed_per_rep += speed_c
                                count += 1
                            if speed_e != 0 and speed_e >= 0.05 and speed_e <= 1.5:
                                speed_per_rep_e += speed_e
                                count_e += 1
                        if count != 0:
                            avg_per_rep = speed_per_rep / count
                        if count_e != 0:
                            avg_per_rep_e = speed_per_rep_e / count_e
                        new_rep = False

                    prev_positions[tracker_id] = (center_x, center_y, frame_number)

                    if speed_text != "Speed: N/A":
                        cv2.putText(
                            annotated_frame,
                            speed_text,
                            (int(center_x) - 50, int(center_y) - 10),
                            # (10,30),
                            cv2.FONT_HERSHEY_SIMPLEX,
                            0.8,
                            (0, 255, 0),
                            1,
                            cv2.LINE_AA
                        )
                    if speed_text_e != "Speed: N/A":
                        cv2.putText(
                            annotated_frame,
                            speed_text_e,
                            (int(center_x) - 50, int(center_y) - 10),
                            # (10,30),
                            cv2.FONT_HERSHEY_SIMPLEX,
                            0.8,
                            (0, 0, 255),
                            1,
                            cv2.LINE_AA
                        )
            cv2.rectangle(
                annotated_frame,
                  (0, 0),
                  (w, 180),
                  (0, 0, 0),
                  -1
                  )
            # cv2.rectangle(
            #     annotated_frame,
            #       (0, h-80)
            #       ,
            #       (w,h),
            #       (0,0,0),
            #       -1
            #       )
            cv2.putText(
                annotated_frame,
                f"Reps: {rep_count}",
                (20, 35),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (136, 150, 0),
                2,
                cv2.LINE_AA
            )
            cv2.putText(
                annotated_frame,
                f"Concentric: {round(vel_rep[-1], 2)}m/s",
                (20, 65),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (136, 150, 0),
                2,
                cv2.LINE_AA
            )
            cv2.putText(
                annotated_frame,
                f"Eccentric: {round(vel_rep_e[-1], 2)}m/s",
                (20, 95),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (136, 150, 0),
                2,
                cv2.LINE_AA
            )
            cv2.putText(
                annotated_frame,
                f"Mean Velocity: {round(avg_c, 2)}m/s",
                (20, 125),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (136, 150, 0),
                2,
                cv2.LINE_AA
            )
            cv2.putText(
                annotated_frame,
                f"Velocity Loss: {round(vel_loss, 2)}%",
                (20, 155),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (136, 150, 0),
                2,
                cv2.LINE_AA
            )
            cv2.rectangle(annotated_frame, (0, 0), (w, 180), (255,255,255), 2)
            # cv2.putText(
            #     annotated_frame,
            #     exercise_name,
            #     (10, h-40),
            #     cv2.FONT_HERSHEY_SIMPLEX,
            #     1,
            #     (255, 255, 0),
            #     2,
            #     cv2.LINE_AA
            # )
            # cv2.putText(
            #     annotated_frame,
            #     f"{barbell_size} barbell ({real_life_barbell_diameter_meters} m)",
            #     (10, h - 10),
            #     cv2.FONT_HERSHEY_SIMPLEX,
            #     1,
            #     (255, 255, 0),
            #     2,
            #     cv2.LINE_AA
            # )

            out.write(annotated_frame)

            frame_number += 1

        cap.release()
        out.release()

        with open(csv_path, 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['Frame', 'Center_X', 'Center_Y', 'Speed_c', 'Speed_e','Repetition'])
            writer.writerows(barbell_positions)
        with open(velocity_path, 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['Repetition', 'Velocity', 'Velocity_e', 'Velocity_loss', 'Mean_velocity'])
            writer.writerows(vel_list)
        exercise = ''
        if exercise_name == 'Back Squat':
            exercise = 1
        else:
            exercise = 0
        new_data = pd.DataFrame({'Exercise':[exercise], 'Velocity_2':[round (avg_c, 2)]})
        intensity = feedback.predict(new_data)
        exercise_table.intensity = intensity[0]
        # print(f"Total reps completed: {rep_count}")
        # print(vel_rep)
        # print(avg_c)
        # print(vel_loss)
        # print(exercise_name)
        # print(barbell_size)
        # print(real_life_barbell_diameter_meters)
        # print(load)
        db.session.commit()

        return send_from_directory(app.config['RESULT_FOLDER'], filename+'_output.mp4')
