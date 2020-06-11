HOST=
USER=
PASSW=
DATABASE=

mongoexport -h $HOST -d $DATABASE -c usuarios -u $USER -p $PASSW -o administradores.csv --csv -f login,password --query '{rol: "Administrador"}'
