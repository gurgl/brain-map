import sbt._
class MyProject(info: ProjectInfo) extends DefaultProject(info) with IdeaProject {
	val asdf = ""
	println("tja ba")

  val coml = "commons-logging" % "commons-logging" % "1.1.1"
  val comb = "commons-beanutils" % "commons-beanutils" % "1.8.3"
  val comc = "commons-collections" % "commons-collections" % "3.2.1"
	lazy val hi = task { println("Hello World"); None }
   // ...

   override def compileOrder = CompileOrder.JavaThenScala
}
