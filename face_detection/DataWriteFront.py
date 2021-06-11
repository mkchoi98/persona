from firebase_admin import credentials
from firebase_admin import firestore, storage
from ResultFront import *
from FirebaseInit import *

users_ref = db.collection(u'result')
docs = users_ref.stream()

for doc in docs:
        if doc.get(u'flag_front') == 1:
            uid = doc.id
            break

users_ref =db.collection(u'result').document(uid)

if error_index != 0:
    users_ref.set({
        u'flag_front':0,
        u'flag_side':0,
        u'error':error_index
    })

else :
    file = 'front_result.png'

    bucket = storage.bucket()
    blob = bucket.blob('front_result/'+file)

    new_token = uuid4()
    metadata = {"firebaseStorageDownloadTokens": new_token} #access token이 필요하다.
    blob.metadata = metadata

    blob.upload_from_filename(file, content_type='image/png')

    users_ref.update({
        u'error':0,
        u'flag_front':0,
        u'faceline_index':faceline_index,
        u'ratio':ratio,
        u'cheek_side':cheek_side,
        u'nose_result':nose_result,
        u'nose_percent':nose_percent,
        u'eyeh_result':eyeh_result,
        u'eyeh_percent':eyeh_percent,
        u'eyew_result':eyew_result,
        u'eyew_percent':eyew_percent,
        u'between_result':between_result,
        u'between_percent':between_percent,
        u'eyeshape_result':eyeshape_result,
        u'shorteye_index':shorteye_result,
        u'lips_result':lips_result,
    })