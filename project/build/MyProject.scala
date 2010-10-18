import sbt._
class MyProject(info: ProjectInfo) extends DefaultProject(info) with IdeaProject {
	val asdf = ""
	println("tja ba")
  
	lazy val hi = task { println("Hello World"); None }
   // ...

   override def compileOrder = CompileOrder.JavaThenScala
}
