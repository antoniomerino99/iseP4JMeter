HOST=
USER=
PASSW=
DATABASE=

mongoexport -h $HOST -d $DATABASE -c usuarios -u $USER -p $PASSW -o alumnos.csv --csv -f login,password --query '{rol: "Alumno"}'
