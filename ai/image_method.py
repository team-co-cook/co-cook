import tensorflow as tf
import numpy as np
from tensorflow import keras
from tensorflow.keras.optimizers import Adam
from PIL import Image

# 모델 로드
model = keras.models.load_model('DenseNet201_0331.h5')

# labels 설정
labels = {0: '000', 1: '001', 2: '002', 3: '003', 4: '004', 5: '005',
        6: '006', 7: '007', 8: '008', 9: '009', 10: '010', 11: '011', 
        12: '012', 13: '013', 14: '014', 15: '015', 16: '016', 17: '017', 
        18: '018', 19: '019', 20: '020', 21: '021', 22: '022', 23: '023', 
        24: '024', 25: '025', 26: '026', 27: '027', 28: '028', 29: '029', 
        30: '030', 31: '031', 32: '032', 33: '033', 34: '034', 35: '035', 
        36: '036', 37: '037', 38: '038', 39: '039', 40: '040', 41: '041', 
        42: '042', 43: '043', 44: '044', 45: '045', 46: '046', 47: '047', 
        48: '048', 49: '049', 50: '050', 51: '051', 52: '052', 53: '053', 
        54: '054', 55: '055', 56: '056', 57: '057', 58: '058', 59: '059', 
        60: '060', 61: '061', 62: '062', 63: '063', 64: '064', 65: '065', 
        66: '066', 67: '067', 68: '068', 69: '069', 70: '070', 71: '071', 
        72: '072', 73: '073', 74: '074', 75: '075', 76: '076', 77: '077', 
        78: '078', 79: '079', 80: '080', 81: '081', 82: '082', 83: '083', 
        84: '084', 85: '085', 86: '086', 87: '087', 88: '088', 89: '089', 
        90: '090', 91: '091', 92: '092', 93: '093', 94: '094', 95: '095', 
        96: '096', 97: '097', 98: '098', 99: '099', 100: '100', 101: '101', 
        102: '102', 103: '103', 104: '104', 105: '105', 106: '106', 107: '107', 
        108: '108', 109: '109', 110: '110', 111: '111', 112: '112', 113: '113', 
        114: '114', 115: '115', 116: '116', 117: '117', 118: '118', 119: '119', 
        120: '120', 121: '121', 122: '122', 123: '123', 124: '124', 125: '125', 
        126: '126', 127: '127', 128: '128', 129: '129', 130: '130', 131: '131', 
        132: '132', 133: '133', 134: '134', 135: '135', 136: '136', 137: '137', 
        138: '138', 139: '139', 140: '140', 141: '141', 142: '142', 143: '143', 
        144: '144', 145: '145', 146: '146', 147: '147', 148: '148', 149: '149'}

# label에 매칭되는 음식
result = {'000': '갈비구이', '001': '갈치구이', '002': '고등어구이', '003': '곱창구이', '004': '닭갈비', 
        '005': '더덕구이', '006': '떡갈비', '007': '불고기', '008': '삼겹살', '009': '장어구이', 
        '010': '조개구이', '011': '조기구이', '012': '황태구이', '013': '훈제오리', '014': '계란국', 
        '015': '떡국_만두국', '016': '무국', '017': '미역국', '018': '북엇국', '019': '시래기국', 
        '020': '육개장', '021': '콩나물국', '022': '과메기', '023': '양념치킨', '024': '젓갈', 
        '025': '콩자반', '026': '편육', '027': '피자', '028': '후라이드치킨', '029': '갓김치', 
        '030': '깍두기', '031': '나박김치', '032': '무생채', '033': '배추김치', '034': '백김치', 
        '035': '부추김치', '036': '열무김치', '037': '오이소박이', '038': '총각김치', '039': '파김치', 
        '040': '가지볶음', '041': '고사리나물', '042': '미역줄기볶음', '043': '숙주나물', '044': '시금치나물', 
        '045': '애호박볶음', '046': '경단', '047': '꿀떡', '048': '송편', '049': '만두', 
        '050': '라면', '051': '막국수', '052': '물냉면', '053': '비빔냉면', '054': '수제비', 
        '055': '열무국수', '056': '잔치국수', '057': '짜장면', '058': '짬뽕', '059': '쫄면', 
        '060': '칼국수', '061': '콩국수', '062': '꽈리고추무침', '063': '도라지무침', '064': '도토리묵', 
        '065': '잡채', '066': '콩나물무침', '067': '홍어무침', '068': '회무침', '069': '김밥', 
        '070': '김치볶음밥', '071': '누룽지', '072': '비빔밥', '073': '새우볶음밥', '074': '알밥', 
        '075': '유부초밥', '076': '잡곡밥', '077': '주먹밥', '078': '감자채볶음', '079': '건새우볶음', 
        '080': '고추장진미채볶음', '081': '두부김치', '082': '떡볶이', '083': '라볶이', '084': '멸치볶음', 
        '085': '소세지볶음', '086': '어묵볶음', '087': '오징어채볶음', '088': '제육볶음', '089': '주꾸미볶음', 
        '090': '보쌈', '091': '수정과', '092': '식혜', '093': '간장게장', '094': '양념게장', 
        '095': '깻잎장아찌', '096': '떡꼬치', '097': '감자전', '098': '계란말이', '099': '계란후라이', 
        '100': '김치전', '101': '동그랑땡', '102': '생선전', '103': '파전', '104': '호박전', 
        '105': '곱창전골', '106': '갈치조림', '107': '감자조림', '108': '고등어조림', '109': '꽁치조림', 
        '110': '두부조림', '111': '땅콩조림', '112': '메추리알장조림', '113': '연근조림', '114': '우엉조림', 
        '115': '장조림', '116': '코다리조림', '117': '전복죽', '118': '호박죽', '119': '김치찌개', 
        '120': '닭계장', '121': '동태찌개', '122': '된장찌개', '123': '순두부찌개', '124': '갈비찜', 
        '125': '계란찜', '126': '김치찜', '127': '꼬막찜', '128': '닭볶음탕', '129': '수육', 
        '130': '순대', '131': '족발', '132': '찜닭', '133': '해물찜', '134': '갈비탕', 
        '135': '감자탕', '136': '곰탕_설렁탕', '137': '매운탕', '138': '삼계탕', '139': '추어탕', 
        '140': '고추튀김', '141': '새우튀김', '142': '오징어튀김', '143': '약과', '144': '약식', 
        '145': '한과', '146': '멍게', '147': '산낙지', '148': '물회', '149': '육회'}

async def find_image(file):
        image = Image.open(file)

        # 이미지 전처리
        image = image.resize((224, 224))
        image = tf.keras.preprocessing.image.img_to_array(image)
        image = tf.keras.applications.densenet.preprocess_input(image)

        # 모델로 이미지 분류
        pred = model.predict(tf.expand_dims(image, axis=0))

        pred = np.argmax(pred,axis=1)
        pred = [labels[k] for k in pred]
        
        return result[pred[0]]