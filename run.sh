lib=$(find lib/ -name '*.jar' -printf "%p:")
lib_managed=$(find lib_managed/scala_2.8.0/compile/ -name '*.jar' -printf "%p:")
tjo=$lib:$lib_managed:target/scala_2.8.0/classes/

echo $tjo

~/apps/javafx-sdk1.3/bin/javafxc -d target/scala_2.8.0/classes/ -classpath project/boot/scala-2.8.0/lib/scala-library.jar:$tjo src/main/fx/se/pearglans/fx/*.fx
if [ $? = 0 ]; then
	~/apps/javafx-sdk1.3/bin/javafx -classpath project/boot/scala-2.8.0/lib/scala-library.jar:$tjo:target/scala_2.8.0/classes/ se.pearglans.fx.StageBase
fi

