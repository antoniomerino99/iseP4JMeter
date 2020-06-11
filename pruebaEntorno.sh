#!/bin/bash
SERVER=
TOKEN=$(curl -s \
-u etsiiApi:laApiDeLaETSIIDaLache \
-d "login=mariweiss@tropoli.com&password=anim" \
-H "Content-Type: application/x-www-form-urlencoded" \
-X POST http://$SERVER/api/v1/auth/login)

resultado=$?
if test "$resultado" != "0"; then
   echo "ERROR: Curl fallo con resultado: $resultado"
fi

curl \
-H "Authorization: Bearer $TOKEN" \
http://$SERVER/api/v1/alumnos/alumno/mariweiss%40tropoli.com
