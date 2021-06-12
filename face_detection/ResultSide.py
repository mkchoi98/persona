import imutils
import mediapipe as mp
from torchvision import transforms
import torch
from PIL import Image
import numpy as np
import dlib
import cv2
import numpy as np
import queue
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore, storage
from uuid import uuid4
import urllib.request

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

                #cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1)

                if (id == 116 or id == 123 or id == 147 or id == 192 or id == 213):  # 앞광대 판별용
                    # print(id,x,y)
                    #pt_pos2 = (x, y)
                    # cheekbone.append([id, pt_pos2])
                    cheekbone.append([id, x, y])
                    cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1) # 보라색rgb = (137, 119, 173)

                #### 출력용 ####

                if (id == 8 or id == 168 or id == 197 or id == 5 or id == 1 or id == 2 or id == 164):  # 콧대 index에만 점을 찍음
                    cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1)
                    
                if (id == 9 or id == 8 or id == 168 or id == 6 or id == 197 or id == 195 or id == 5 or id == 4 or id == 1 or id == 2):  # 콧대 index에만 점을 찍음
                    cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1)

                if (id == 18 or id == 200 or id == 199 or id == 175 or id ==0 or id == 13 or id == 14 or id == 15 or id == 16 or id == 17):  # 앞턱 index에만 점을 찍음
                    cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1)

                if (id == 152 or id == 377 or id == 400 or id == 378 or id == 379 or id == 365 or id == 397 or id == 288 or id == 361):  # 옆턱 index에만 점을 찍음
                    cv2.circle(image_side, (x, y), 2, (0, 255, 0), -1)

    m = (cheekbone[3][2] - cheekbone[1][2]) / (cheekbone[3][1] - cheekbone[1][1])  # 123번-192번 기울기

    #print("기울기", m)

    if (m <= 3.45):
        #print("앞광대 O")
        cheek_side = 1
    else:
        #print("앞광대 X")
        cheek_side = 0

    return cheek_side

error_index = 0 # 0:정상 1:랜드마크 검출 오류 2:얼굴형 오류 3:얼굴 비율 오류 4:헤어라인 오류 5:이목구비 계산 오류

image_side_origin = cv2.imread("side.png")
image_side = imutils.resize(image_side_origin, height=500)
image_front_origin = cv2.imread("front.png")
image_front = imutils.resize(image_front_origin, height=500)  # image 크기 조절

try :
    center, low, list_points = face_detection(image_front)

    cheek_front = front_cheekbone_have(list_points,image_side)
    cv2.imwrite('side_result.png', image_side)

except NameError as e:
    error_index = 1
