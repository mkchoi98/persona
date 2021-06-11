import firebase_admin
from firebase_admin import credentials, firestore
import time
import threading
import urllib.request
from os import system

print('Initializing Firestore connection...')
# Credentials and Firebase App initialization. Always required
firCredentials = credentials.Certificate('persona-d1ed9-firebase-adminsdk-pyf6e-951437f2bf.json')
firApp = firebase_admin.initialize_app (firCredentials)

# Get access to Firestore
db = firestore.client()
print('Connection initialized')

# Create an Event for notifying main thread.
callback_done = threading.Event()

# Create a callback on_snapshot function to capture changes
def on_snapshot1(col_snapshot, changes, read_time):
    
    print(u'Callback received query snapshot.')
    
    if not col_snapshot:
        return

    for change in changes:
        if change.type.name == 'ADDED':
            # print(f'uid : {change.document.id}')
            uid = f'{change.document.id}'
            #print(uid)

            user_ref = db.collection(u'result').document(uid)
            doc = user_ref.get()
            
            if doc.exists:
                # print(f'Document data: {doc.to_dict()}')
                url_front = doc.get('imageurl_front')
            else:
                print(u'No such document!')
    
            urllib.request.urlretrieve(url_front, "front.png")
            
            system("python DataWriteFront.py")

            
    callback_done.set()

def on_snapshot2(col_snapshot, changes, read_time):
    
    print(u'Callback received query snapshot.')
    
    if not col_snapshot:
        return

    for change in changes:
        if change.type.name == 'ADDED':
            # print(f'uid : {change.document.id}')
            uid = f'{change.document.id}'
            #print(uid)

            user_ref = db.collection(u'result').document(uid)
            doc = user_ref.get()
            
            if doc.exists:
                # print(f'Document data: {doc.to_dict()}')
                url_side = doc.get('imageurl_side')
            else:
                print(u'No such document!')

            urllib.request.urlretrieve(url_side, "side.png")
            
            system("python DataWriteSide.py")

            
    callback_done.set()
    
while True:
    print('processing...')
    col_query1 = db.collection(u'result').where(u'flag_front', u'==', 1)
    col_query2 = db.collection(u'result').where(u'flag_side', u'==', 1)
    
    query_watch = col_query1.on_snapshot(on_snapshot1)
    query_watch = col_query2.on_snapshot(on_snapshot2)
    
    time.sleep(4)