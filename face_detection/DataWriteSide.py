from firebase_admin import credentials
from firebase_admin import firestore, storage
from ResultSide import *
from FirebaseInit import *

users_ref = db.collection(u'result')
docs = users_ref.stream()


for doc in docs:
    if doc.get(u'flag_side') == 1:
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
    file = 'side_result.png'

    bucket = storage.bucket()
    blob = bucket.blob('side_result/'+file)

    new_token = uuid4()
    metadata = {"firebaseStorageDownloadTokens": new_token} #access token이 필요하다.
    blob.metadata = metadata

    blob.upload_from_filename(file, content_type='image/png')

    users_ref.update({
        u'flag_side':0,
        u'error':0,
        u'cheek_front':cheek_front
    })