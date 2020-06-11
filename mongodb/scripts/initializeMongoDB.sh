HOST=
USER=
PASSW=
DATABASE=


mongo $HOST/$DATABASE --eval 'db.alumnos.drop();' -u $USER -p $PASSW
mongo $HOST/$DATABASE --eval 'db.usuarios.drop();' -u $USER -p $PASSW
mongoimport -h $HOST -d $DATABASE -c alumnos -u $USER -p $PASSW --file generated_alumnos.json --jsonArray
mongo $HOST/$DATABASE --eval 'db.alumnos.createIndex({"email":1},{"unique":1});' -u $USER -p $PASSW
mongo $HOST/$DATABASE --eval 'db.alumnos.find({},{usuarioObj:1,_id:0}).forEach(function(d){db.usuarios.insert((d.usuarioObj))});' -u $USER -p $PASSW
mongo $HOST/$DATABASE --eval 'db.alumnos.update({}, {$unset: {usuarioObj: 1}}, {multi: true});' -u $USER -p $PASSW
mongo $HOST/$DATABASE --eval 'db.usuarios.createIndex({"id":1},{"unique":1});' -u $USER -p $PASSW
mongoimport -h $HOST -d $DATABASE -c usuarios -u $USER -p $PASSW --file generated_admin.json --jsonArray
