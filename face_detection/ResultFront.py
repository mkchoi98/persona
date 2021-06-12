import imutils
import mediapipe as mp
from torchvision import transforms
import torch
from PIL import Image
import numpy as np
import dlib
import cv2
import numpy as np
import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
from firebase_admin import firestore
from uuid import uuid4
from os import system

# 얼굴형 분류해서 return 에는 얼굴형 인덱스가 출력될 것임!
def faceline(image_front, PATH):
    class_names = ["각진형", "계란형 ", "둥근형", "마름모형", "하트형"]

    transforms_test = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

    device = torch.device("cpu")

    # 모델 초기화
    model = torch.load(PATH, map_location=torch.device('cpu'))
    # 모델 불러오기
    # 드롭아웃 및 배치 정규화를 평가 모드로 설정
    model.eval()
    # 이미지 불러오기
    image = transforms_test(image_front).unsqueeze(0).to(device)

    # 불러온 이미지를 얼굴형 분류 모델에 집어넣기
    with torch.no_grad():
        outputs = model(image)
        _, preds = torch.max(outputs, 1)
        num = preds[0].tolist()

    return num

def face_detection(image_front):
    gray = cv2.cvtColor(image_front, cv2.COLOR_BGR2GRAY)
    rects = detector(gray, 1)

    for face in rects:
        shape = predictor(gray, face)

        list_points = []
        for p in shape.parts():
            list_points.append([p.x, p.y])

        list_points = np.array(list_points)

        for i, pt in enumerate(list_points[ALL]):
            pt_pos = (pt[0], pt[1])
            cv2.circle(image_front, pt_pos, 2, (0, 255, 0), -1)


    center = (list_points[NOSE][6] - -list_points[RIGHT_EYEBROW][4])[1]
    low = (list_points[JAWLINE][8] - list_points[NOSE][6])[1]

    return  center, low, list_points

def hair_up (img1,list_points):
    cascadePath = "haarcascade_frontalface_default.xml"
    faceCascade = cv2.CascadeClassifier(cascadePath)

    def get_head_mask(img):
        """
        Get the mask of the head
        Cuting  BG
        :param img: source image
        :return:   Returns the mask with the cut out BG
        """
        mask = np.zeros(img.shape[:2], np.uint8)
        bgdModel = np.zeros((1, 65), np.float64)
        fgdModel = np.zeros((1, 65), np.float64)
        faces = faceCascade.detectMultiScale(img, scaleFactor=1.1, minNeighbors=5, minSize=(50, 50))  # Find faces
        if len(faces) != 0:
            x, y, w, h = faces[0]
            (x, y, w, h) = (x - 40, y - 100, w + 80, h + 200)
            rect1 = (x, y, w, h)
            cv2.grabCut(img1, mask, rect1, bgdModel, fgdModel, 5, cv2.GC_INIT_WITH_RECT)  # Crop BG around the head
        mask2 = np.where((mask == 2) | (mask == 0), 0, 1).astype('uint8')  # Take the mask from BG

        return mask2

    def is_bold(pnt, hair_mask):
        """
        Check band or not
        :param pnt: The upper point of the head
        :param hair_mask: Mask with hair
        :return: True if Bald, else False
        """
        roi = hair_mask[pnt[1]:pnt[1] + 40, pnt[0] - 40:pnt[0] + 40]  # Select the rectangle under the top dot
        cnt = cv2.countNonZero(roi)  # Count the number of non-zero points in this rectangle
        # If the number of points is less than 25%, then we think that the head is bald
        # print("cntttt", cnt)
        if cnt < 0:
            # print("Bald human on photo")
            return True
        else:
            # print("Not Bold")
            return False


    mask = get_head_mask(img1)

    cnts = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)[1]
    cnts = sorted(cnts, key=cv2.contourArea, reverse=True)
    cnt = cnts[0]
    topmost = tuple(cnt[cnt[:, :, 1].argmin()][0])

    lower = np.array([0, 0, 100], dtype="uint8")  # Lower limit of skin color
    upper = np.array([255, 255, 255], dtype="uint8")  # Upper skin color limit
    converted = cv2.cvtColor(img1, cv2.COLOR_BGR2HSV)  # We translate into HSV color format
    skinMask = cv2.inRange(converted, lower, upper)  # Write a mask from places where the color is between the outside
    mask[skinMask == 255] = 0  # We remove the face mask from the mask of the head

    kernel1 = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
    mask = cv2.dilate(mask, kernel1, iterations=1)
    i1 = cv2.bitwise_and(img1, img1, mask=mask)

    if is_bold(topmost, mask):
        cv2.rectangle(img1, topmost, topmost, (0, 0, 255), 5)
        #print(topmost)



    # Otherwise we write that we are not bald and display the coordinates of the largest contour
    else:
        cnts = cv2.findContours(mask.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)[1]
        cnts = sorted(cnts, key=cv2.contourArea, reverse=True)

        len_cnts = len(cnts[0])
        max_y = 0
        for c in range(len_cnts):
            point = (cnts[0][c][0][0], cnts[0][c][0][1])

            if (point[0] >= list_points[NOSE][0][0] - 5 and point[0] <= (list_points[NOSE][0][0]) + 5):

                if (max_y < point[1]):
                    max_y = point[1]

        hair_line_point = list_points[NOSE][0][0], max_y
        cv2.circle(img1, (list_points[NOSE][0][0], max_y), 2, (0, 255, 0), -1)

    up = (list_points[RIGHT_EYEBROW][4] - hair_line_point)[1]

    return up, hair_line_point

def face_length_ratio (up, center, low):
    # 상중하안부 비율의 기준 정하기
    if (up < center):
        if (up < low):
            criteria = up
        else:
            criteria = low

    elif (center < low):
        if (center < up):
            criteria = center
        else:
            criteria = up

    elif (low < up):
        if (low < center):
            criteria = low
        else:
            criteria = center

    # 상중하안부 비율
    upper_ratio = round(abs(up / criteria), 1)
    center_ratio = round(abs(center / criteria), 1)
    lower_ratio = round(abs(low / criteria), 1)
    #print(upper_ratio, center_ratio, lower_ratio)

    if (upper_ratio == center_ratio and upper_ratio == lower_ratio):
        ratio = 0  # 1:1:1
    elif (upper_ratio >= center_ratio and upper_ratio >= lower_ratio):
        ratio = 1  # 상안부 길 때
    elif (center_ratio >= lower_ratio and center_ratio >= upper_ratio):
        ratio = 2  # 중안부 길 때
    elif (lower_ratio >= upper_ratio and lower_ratio >= center_ratio):
        ratio = 3  # 하안부 길 때
    elif (lower_ratio == center_ratio and upper_ratio < center_ratio and upper_ratio < lower_ratio):
        ratio = 4  # 상안부가 가장 짧을 때
    
    return ratio

# 옆광대 여부
def side_cheekbone_have(list_points):
    flag = 0
    x = (list_points[JAWLINE][1] - list_points[JAWLINE][2])[0]
    y = (list_points[JAWLINE][1] - list_points[JAWLINE][2])[1]
    #print(abs(y/x))
    if (abs(y / x) >= 6.8): flag = 1
    
    return flag

def nose_detection(list_points,image_front):

    #pTime = 0

    mpDraw = mp.solutions.drawing_utils
    mpFaceMesh = mp.solutions.face_mesh
    faceMesh = mpFaceMesh.FaceMesh(max_num_faces=2)
    drawSpec = mpDraw.DrawingSpec(thickness=1, circle_radius=2)

    imgRGB = cv2.cvtColor(image_front, cv2.COLOR_BGR2RGB)
    results = faceMesh.process(imgRGB)

    nose = []
    if results.multi_face_landmarks:
        for faceLms in results.multi_face_landmarks:
            for id,lm in enumerate(faceLms.landmark):
                ih, iw, ic = image_front.shape
                x, y = int(lm.x * iw), int(lm.y * ih)

                if (id == 102 or id == 278):  # 콧볼
                    #print("콧볼", id, x, y)
                    cv2.circle(image_front, (x, y), 2, (0, 255, 0), -1)
                    nose.append([x, y])

    nose_w = abs(nose[0][0] - nose[1][0])
    ratio_nose = abs(face_w/nose_w)

    # print("콧볼", ratio_nose)

    if (ratio_nose >= 3.2 and ratio_nose <= 4.0): # 평균 3.825
        nose_result = 0
        nose_percent = 0
        #print("콧볼 크기는 평균입니다")
    elif (ratio_nose < 3.2):
        nose_result = 1
        nose_percent = round(abs(3.6 - ratio_nose),2)
        #print("콧볼", ratio_nose)
        #print("콧볼 크기는 평균보다 %.1f%% 큰 편입니다" % (abs(nose[0][0] - list_points[RIGHT_EYE][3][0]) / face_w))
    elif (ratio_nose >= 4.0):
        nose_result = -1
        nose_percent = round(abs(3.6 - ratio_nose),2)
        #print("콧볼", ratio_nose)
        #print("콧볼 크기 %.1f%% 작은 편입니다" % (abs(nose[0][0] - list_points[RIGHT_EYE][3][0]) / face_w))

    return nose_result, nose_percent

#눈 가로
def eyew_detection(list_points):
    reye_w = abs(list_points[RIGHT_EYE][0] - list_points[RIGHT_EYE][3])[0]  # 오른쪽 눈 가로

    ratio_eyew = abs(face_w / reye_w)

    #print("눈 가로", ratio_eyew)

    if (ratio_eyew >= 5.0 and ratio_eyew <= 5.3):  # 평균값 = 5.675
        eyew_result = 0
        eyew_percent = 0
        #print("눈 가로 길이는 평균")
    elif (ratio_eyew < 5.0):
        eyew_result = 1
        eyew_percent = round(abs(5.15 - ratio_eyew),2)
        #print("눈 가로 길이 평균보다 %.1f%% 긴 편" % (abs(5.675 - ratio_eyew)))
    elif (ratio_eyew > 5.3):
        eyew_result = -1
        eyew_percent = round(abs(5.15 - ratio_eyew),2)
        #print("눈 가로 길이 평균보다 %.1f%% 짧은 편" % (abs(5.675 - ratio_eyew)))

    return eyew_result, eyew_percent

#눈 세로
def eyeh_detection(list_points):
    reye_h = abs(list_points[RIGHT_EYE][1] - list_points[RIGHT_EYE][5])[1]  # 오른쪽 눈 세로

    ratio_eyeh = abs(face_h / reye_h)

    #print("눈 세로", ratio_eyeh)

    if (ratio_eyeh >= 19 and ratio_eyeh <= 23.6):  # 평균비 = 24
        eyeh_result = 0
        eyeh_percent = 0
        # print("눈 세로 길이 평균")
    elif (ratio_eyeh < 19):
        eyeh_result = 1
        eyeh_percent = round(abs(21.3 - ratio_eyeh),2)
        # print("눈 세로 길이 평균보다 %.1f%% 긴 편" % (abs(23.8 - ratio_eyeh)))
    elif (ratio_eyeh > 23.6):
        eyeh_result = -1
        eyeh_percent = round(abs(21.3 - ratio_eyeh),2)
        # print("눈 세로 길이 평균보다 %.1f%% 짧은 편" % (abs(23.8 - ratio_eyeh)))

    return eyeh_result, eyeh_percent

#입술 가로
def lips_detection(list_points):
    lips_w = abs(list_points[MOUTH_OUTLINE][0] - list_points[MOUTH_OUTLINE][6])[0]  # 입술 가로

    ratio_lips = face_w / lips_w
    #print("입술", ratio_lips)

    if (ratio_lips >= 2.3 and ratio_lips <= 3.3):
        lips_result = 0 # 입술 가로 길이 평균
    elif (ratio_lips < 2.3):
        lips_result = 1 # 입술 가로 길이 긴 편
    elif (ratio_lips > 3.3):
        lips_result = -1 # 입술 가로 길이 짧은 편

    return lips_result


#미간거리
def between_detection(list_points):
    eyetoeye = abs(list_points[RIGHT_EYE][3] - list_points[LEFT_EYE][0])[0]  # 미간 거리
    between_ratio = abs(face_w / eyetoeye)

    #print("미간", between_ratio)

    if (between_ratio >= 3.2 and between_ratio < 3.4):
        between_result = 0
        between_percent = 0
        #print("미간 평균 ", between_ratio)

    elif (between_ratio < 3.2):
        between_result = -1
        between_percent = round(abs(3.3 - between_ratio), 2)
        #print("미간 짧은 편 ", between_ratio)
        #미간 긴 편
    elif (between_ratio > 3.4):
        between_result = 1
        between_percent = round(abs(3.3 - between_ratio), 2)
        #print("미간 긴 편 ", between_ratio)

        #미간 짧은편

    return between_result, between_percent

#눈꼬리
def eyeshape_detection(list_points):

    p1 = list_points[RIGHT_EYE][0][0]
    p2 = list_points[RIGHT_EYE][1][1]
    p3 = list_points[RIGHT_EYE][2][1]
    p4 = list_points[RIGHT_EYE][3][0]
    p5 = list_points[RIGHT_EYE][4][1]
    p6 = list_points[RIGHT_EYE][5][1]

    if (p1 == p4): #p4가 내려갈수록 값이 크게 나옴
        eyeupdown = 0
    else:
        #print(p1, p2, p3, p4, p5, p6)
        eyeupdown = (abs(p2 - p6) + abs(p3 - p5)) / (2 * (abs(p4 - p1)))

    #print("눈의 비율", eyeupdown)
    if (eyeupdown >= 0.36):
        eyeshape_result = 1 # 눈꼬리 올라감
    elif (eyeupdown >= 0.32):
        eyeshape_result = 0 # 눈꼬리 보통
    else:
        eyeshape_result = -1 # 눈꼬리 내려감

    return eyeshape_result

# 앞광대 여부
def front_cheekbone_have(list_points,image_side):
    
    #pTime = 0

    mpDraw = mp.solutions.drawing_utils
    mpFaceMesh = mp.solutions.face_mesh
    faceMesh = mpFaceMesh.FaceMesh(max_num_faces=2)
    drawSpec = mpDraw.DrawingSpec(thickness=1, circle_radius=2)

    imgRGB = cv2.cvtColor(image_side, cv2.COLOR_BGR2RGB)
    results = faceMesh.process(imgRGB)

    cheekbone = []
    if results.multi_face_landmarks:
        for faceLms in results.multi_face_landmarks:
            for id,lm in enumerate(faceLms.landmark):
                ih, iw, ic = image_side.shape
                x, y = int(lm.x * iw), int(lm.y * ih)

                if (id == 116 or id == 123 or id == 147 or id == 192 or id == 213):  # test
                    # print(id,x,y)
                    #pt_pos2 = (x, y)
                    # cheekbone.append([id, pt_pos2])
                    cheekbone.append([id, x, y])
                    cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1)

    m = (cheekbone[3][2] - cheekbone[1][2]) / (cheekbone[3][1] - cheekbone[1][1])  # 123번-192번 기울기

    #print("기울기", m)

    if (m <= 3.45):
        #print("앞광대 O")
        cheek_front = 1
    else:
        #print("앞광대 X")
        cheek_front = 0

    return cheek_side
    
error_index = 0 # 0:정상 1:랜드마크 검출 오류 2:얼굴형 오류 3:얼굴 비율 오류 4:헤어라인 오류 5:이목구비 계산 오류

# 이미지 읽어오기
image_front_origin = cv2.imread("front.png")
image_faceline = Image.open("front.png")

    # 얼굴형 분류 모델의 위치 = PATH
PATH = 'model_26.pt'

image_front = imutils.resize(image_front_origin, height=500)  # image 크기 조절

detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')

ALL = list(range(0, 68))
RIGHT_EYEBROW = list(range(17, 22))
LEFT_EYEBROW = list(range(22, 27))
RIGHT_EYE = list(range(36, 42))
LEFT_EYE = list(range(42, 48))
NOSE = list(range(27, 36))
MOUTH_OUTLINE = list(range(48, 61))
MOUTH_INNER = list(range(61, 68))
JAWLINE = list(range(0, 17))  # index 1, 15 = 옆광대

index = ALL
    
error_index = 0

try:
    faceline_index = faceline(image_faceline, PATH)

    center, low, list_points = face_detection(image_front)

    # 얼굴 비율 구할 때 필요한 맨 위 점 (헤어 라인 점)
    up, hair_line_point = hair_up(image_front,list_points)
    if (hair_line_point[1] >= list_points[LEFT_EYEBROW][0][1] or hair_line_point[1] >= list_points[RIGHT_EYEBROW][4][1]):
        error_index = 1

    #cv2.imshow("front result", image_front)
    cv2.imwrite('front_result.png', image_front)

    face_w = abs(list_points[JAWLINE][1]-list_points[JAWLINE][15])[0] # 얼굴 가로
    face_h = abs(list_points[JAWLINE][8]-hair_line_point)[1] # 얼굴 세로

    # 얼굴 상중하 비율 0: 1:1:1  1:상안부 길때  2:중안부 길 때  3:하안부 길때  4:상안부 제일 짧을때
    ratio = face_length_ratio(up, center, low)

    # 옆광대 유무 1: 있음 , 0: 없음
    cheek_side = side_cheekbone_have(list_points)

    # 콧볼 0: 평균 , 1: 큼 , -1: 작음
    nose_result, nose_percent = nose_detection(list_points,image_front)

    # 눈 세로 0: 평균 , 1: 큼 , -1: 작음
    eyeh_result, eyeh_percent = eyeh_detection(list_points)

    # 눈 가로 0: 평균 , 1: 큼 , -1: 작음
    eyew_result, eyew_percent = eyew_detection(list_points)

    # 미간 0: 평균 , 1: 큼 , -1: 작음
    between_result, between_percent = between_detection(list_points)

    # 눈꼬리 1: 올라감 0: 보통 -1: 내려감
    eyeshape_result = eyeshape_detection(list_points)

    # 꼬막눈 1:꼬막눈 0:꼬막눈 아님
    if(eyeshape_result == 1 and eyew_result == -1): #올라간 눈이면서 눈 짧으면
        shorteye_result = 1 # 꼬막눈 O
    else:
        shorteye_result = 0 # 꼬막눈 X

    # 입술가로 1: 큼 0: 평균 -1: 작음
    lips_result = lips_detection(list_points)

except NameError as e:
    error_index = 1
