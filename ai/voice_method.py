import librosa
import numpy as np
from tensorflow.keras.models import load_model
import pickle

# 라벨 정보 로드
with open('label_encoder.pkl', 'rb') as f:
    label_encoder = pickle.load(f)

# 모델 파일 로드
model = load_model('model.h5')

def cut_voice(file_path):
    # 불러오기
    y, sample_rate = librosa.load(file_path, sr=None)
    
    # 계산 부분
    frame_size = 0.025
    frame_stride = 0.01
    frame_length = int(round(frame_size * sample_rate))
    frame_step = int(round(frame_stride * sample_rate))
    energy = np.array([sum(abs(y[i:i+frame_length]**2)) for i in range(0, len(y)-frame_length, frame_step)])

    threshold = np.mean(energy) * 0.1

    # 말하는 부분 찾기
    speech = []
    non_speech = []
    for i, e in enumerate(energy):
        if e > threshold:
            speech.append(i)
        else:
            non_speech.append(i)

    # 하나로 만들기
    segments = []
    start = speech[0]
    for i in range(1, len(speech)):
        if speech[i] - speech[i-1] > 1:
            segments.append((start, speech[i-1]))
            start = speech[i]
    segments.append((start, speech[-1]))

    # 결과
    samples = np.concatenate([y[start*frame_step:end*frame_step] for start, end in segments])

    return samples, sample_rate

def extract_features(audio, sample_rate, flag=0):
    try:   
        if flag == 1: # 작은 노이즈
            cf = 0.95
            noise = np.random.normal(scale=0.05, size=len(audio))
            audio = librosa.effects.preemphasis(audio + 0.1 * noise, coef=cf)
        elif flag == 2: # 큰 노이즈
            cf = 0.95
            noise = np.random.normal(scale=0.05, size=len(audio))
            audio = librosa.effects.preemphasis(audio + 0.3 * noise, coef=cf)
        elif flag == 3: # 길이 증가
            audio = librosa.effects.time_stretch(audio, rate=1.2)
        elif flag == 4: # 길이 줄이기
            audio = librosa.effects.time_stretch(audio, rate=0.8)

        # 멜스펙트럼으로 변환
        mel_spec = librosa.feature.melspectrogram(y=audio, sr=sample_rate, n_mels=128)
        mel_spec_db = librosa.power_to_db(mel_spec, ref=np.max)
        mel_spec_processed = np.mean(mel_spec_db.T, axis=0)

    except Exception as e:
        print(f"Error encountered while parsing file:, {e}")
        return None

    return mel_spec_processed

def result(file_path):
    print(file_path)
    audio, sample_rate = cut_voice(file_path)
    new_features = extract_features(audio, sample_rate)
    new_features_reshaped = np.reshape(new_features, (1, new_features.shape[0], 1))

    predictions = model.predict(new_features_reshaped)
    predicted_class_index = np.argmax(predictions)
    predicted_class_label = label_encoder.inverse_transform([predicted_class_index])[0]
    print(f"예측된 클래스 레이블: {predicted_class_label}")

# 예측된 레이블을 카테고리로 변환

    predicted_class_probability = predictions[0][predicted_class_index]
    percentage = predicted_class_probability * 100
    print(f"일치율: {percentage:.2f}%")
    print(predictions)
    return predicted_class_label