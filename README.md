

# iseP4JMeter
Código para el ejercicio de JMeter Práctica 4

El ejercicio consiste en realizar una prueba de carga de una API Rest empleando JMeter.

La API se ha desarrollado empleando:
* MongoDB
* NodeJS
* Express

El código se encuentra en el repositorio para su revisión por el alumno en caso de interés. Su desarrollo queda fuera del ámbito de esta asignatura.

El servidor se encuentra desplegado en Heroku (https://practica4-ise.herokuapp.com). Además está configurado para desplegarse automáticamente cada vez que se realice un push sobre la rama master.

El proceso seguido para obtener dicha configuración ha sido el siguiente. Primero se accede a https://heroku.com y se crea una cuenta. A continuación, se crea una aplicación y se le da un nombre, que en este caso ha sido "practica4-ise". En la opción "Deploy" del menú, concretamente en el apartado "Deployment Method", se selecciona GitHub. Se introduce ahí el usuario de GitHub y el repositorio en el que se encuentra el código de la aplicación.

Posteriormente, debe configurarse la base de datos. Esto se realiza por línea de comandos, de modo que hay descargar The Heroku Command Line Interface (https://devcenter.heroku.com/articles/heroku-cli). Una vez descargado, se inicia sesión en la cuenta de Heroku y se añade a la aplicación creada el complemento de mLab-MongoDB. (Se trata de un complemento gratuito pero que requiere haber asociado previamente una tarjeta de crédito a la cuenta de Heroku).

> heroku login -i
>
> heroku addons:create mongolab -a <nombre-app>

De esta manera se ha creado una base de datos de MongoDB y se ha vinculado a la aplicación creada. Seguidamente, hay que rellenar la base de datos. Con el siguiente comando se obtiene la URI de la base de datos:

> heroku config:get MONGODB_URI -a <nombre-app>

Será una URI del siguiente formato:

> mongodb://USER:PASSWORD@HOST/DATABASE

En el script "/mongodb/scripts/initializeMongoDB.sh" se le asigna el valor correspondiente a las variables "HOST", "USER", "PASSW" y "DATABASE" de acuerdo con la URI antes obtenida. Ejecutando dicho script desde el directorio "/mongodb/scripts/" se rellena la base de datos.

A continuación, se activa el despliegue automático de la aplicación en Heroku. Para ello hay que dirigirse en la interfaz web de Heroku al apartado "Deploy" y, teniendo seleccionado "GitHub" como "Deployment method", seleccionamos la opción "Enable Automatic Deploys" del apartado "Automatic Deploys". De esta manera, el despliegue automático queda ya correctamente configurado.


Accediendo con un navegador a https://practica4-ise.herokuapp.com se  presenta la descripción básica de la api. Se tratan de dos métodos:
* /auth/login: Permite identificarse al usuario como Alumno o Administrador. El acceso a este servicio está protegido por Http BasicAuth. Una vez autenticado, se obtiene un [JWT](https://jwt.io) Token para ser empleado en el servicio de alumno.
* /alumnos/alumno: Devuelve el registro de calificaciones del alumno. Los administradores pueden consultar los datos de cualquier alumno. Los alumnos solo los propios. Se debe proporcionar un JWT válido (obtenido en el login) que portará la identidad (autenticación) y rol (autorización) del usuario.

El proceso de consulta es el siguiente:
1. Identificarse en el servicio de login proporcionando credenciales de válidas de alumno o administrador. Obteniendo un token.
2. Solicitar los datos del propio alumno identificado (alumno) o de un grupo de alumnos (administrador).

Para una prueba más detallada de que el entorno funciona, instala [curl](https://curl.haxx.se) y ejecuta el script:
> pruebaEntorno.sh

Este script contiene la secuencia descrita anteriormente en invocaciones a curl, por lo que describe las operaciones a realizar. La primera línea contiene la variable SERVER, en la que hay que introducir la dirección al servidor (practica4-ise.herokuapp.com) . Si todo está correctamente configurado, obtendrá el perfil de un alumno, como el ejemplo siguiente:

```json
{
   "_id": "5cdfd96c6731c5f7bc5b552d",
   "nombre": "Mari",
   "apellidos": "Fletcher Weiss",
   "sexo": "female",
   "email": "mariweiss@tropoli.com",
   "fechaNacimiento": "1992-04-04T00:00:00.000Z",
   "comentarios": "Aliquip dolor laboris ullamco id ex labore. Ipsum eiusmod ut aliquip non cillum deserunt sunt commodo anim ad nisi excepteur eu deserunt. Sit sunt proident Lorem irure irure minim adipisicing cillum. Nostrud officia in proident velit velit sit fugiat pariatur quis ad laboris minim dolor elit. Sint velit pariatur commodo sint veniam exercitation. Duis proident minim consequat consectetur sint et tempor labore culpa esse. Exercitation laborum non esse mollit tempor ea dolor minim adipisicing mollit in aliqua.\r\nUllamco adipisicing excepteur commodo sunt nulla quis sunt velit Lorem pariatur sunt ad do incididunt. In eu nostrud ullamco laboris eu minim. Consequat sit et eiusmod officia ex sit minim sit laborum quis laborum labore non. Dolor nulla ut pariatur reprehenderit minim dolore consequat sunt aliquip ipsum esse. Excepteur consequat fugiat elit et nisi dolore aute minim nostrud et.\r\n",
   "cursos": [
     {
       "curso": 1,
       "media": 5.2
     },
     {
       "curso": 2,
       "media": 9.1
     }
   ],
   "usuario": 10
}
```

Los datos de alumnos se han generado automáticamente empleando la herramienta [Json-Genrator](https://www.json-generator.com), con las plantillas situadas en /[mongodb/scripts](https://github.com/davidPalomar-ugr/iseP4JMeter/tree/master/mongodb):

> json-generator_administradores.json
>
> json-generator_alumnos.json

El subdirectorio [JMeter](https://github.com/davidPalomar-ugr/iseP4JMeter/tree/master/jMeter) contiene los archivos necesarios para realizar la sesión de prácticas:
* alumnos.csv: Archivo con credenciales de alumnos
 * administradores.csv: Archivo con credenciales de administradores
 * apiAlumno.log: Log de accesso Http en formato apache.

La prueba de JMeter debe:
* Parametrizar el "EndPoint" del servicio mediante variables para la dirección y puerto del servidor. Emplee "User Defined Variables" del Test Plan.
* Definir globalmente las propiedades de los accesos Http y la Autenticacion Basic. Emplee HTTP Request Defatuls y HTTP Authorization Manager.
* Los accesos de alumnos y administradores se modelarán con 2 Thread Groups independientes. La carga de accesos de administradores se modelará empleando el registro de accesos  del archivo apiAlumno.log

La imagen siguiente presenta un posible diseño de la carga:

![JMeterLoadTest](images/jmeterLoadTest.png)

En la URL https://practica4-ise.herokuapp.com/status se puede monitorizar el estado de carga del servidor NodeJS.
