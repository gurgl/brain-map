lib=$(find lib/ -name '*.jar' -printf "%p:")
lib_managed=$(find lib_managed/scala_2.8.0/compile/ -name '*.jar' -printf "%p:")
tjo=$lib:$lib_managed:target/scala_2.8.0/classes/

echo $tjo

~/apps/javafx-sdk1.3/bin/javafxc -classpath $tjo:project/boot/scala-2.8.0/lib/scala-library.jar src/main/fx/se/pearglans/fx/*.fx
if [ $? = 0 ]; then
	~/apps/javafx-sdk1.3/bin/javafx -classpath $tjo:project/boot/scala-2.8.0/lib/scala-library.jar:src/main/fx/ se.pearglans.fx.StageBase
fi

