package se.pearglans

import reflect.{BeanProperty, BeanInfo}

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-nov-30
 * Time: 16:24:40
 * To change this template use File | Settings | File Templates.
 */

object Tjo {

  var model:MNode = _

  def loadExampleModel : MNode = {
    println("Load example")

    val r = new MNode(new Point2D(50,50),"tja")
    val child11 = new MNode(new Point2D(150,50),"tja2")
    val child12 = new MNode(new Point2D(50,150),"tja3")
    val child21 = new MNode(new Point2D(150,150),"tja4")
    r.children = List(child11,child12)
    child12.children = List(child21)

    model = r
    r
  }

  private def dig(n:MNode) : List[MNode] = {
    n :: n.children.flatMap(
      c => dig(c)
    )
  }

  def flatten(node:MNode) : Array[MNode] = {
    val r = dig(node)
    r.toArray
  }

  def flattened() : List[MNode] = {
    dig(model)
  }

  def moveNode(node:MNode,newParent:MNode) : MNode = {
    val parentOfRemoved = removeNode(node)
    newParent.add(node)
    parentOfRemoved
  }

  def removeNode(n:MNode) : MNode = {
    val allNodes = flattened
    println("REMO BEF " + allNodes.size)
    allNodes.foreach(println(_))
    val parentOfRemoved = allNodes.find(_.children.contains(n)) match {
      case Some(s) =>
        println("parent is " + s)
        s.children = s.children.filterNot(_ == n)
        s
      case None => throw new IllegalStateException("Bad state")
    }

    println("REMO AFT " + flattened.size)
    flattened.foreach(println(_))
    parentOfRemoved
  }

  def findByName(s:String) : MNode = {
    val allNodes = flattened
    allNodes.find( _.text.startsWith(s)) match {
      case Some(n) => n
      case None => null
    }
  }
}


trait NodeModelView {

}


case class MNode(@BeanProperty val pos:Point2DBean, var text:String) extends HasPropertyChangeListener {
  //List[MNode]
  //def this() = this(Nil,null)
  //def this(p:Point2D) = this(Nil,p)

  def this(p:Point2D,t:String) = this(new Point2DBean(p.x,p.y),t)
  scala.collection.mutable.ListBuffer
  var children:List[MNode] = Nil

  import scala.collection.JavaConversions._

  def getChildren : java.util.List[MNode] = {
    val r = asList(children)
    //println(children.size)
    if(r == null)
      throw new RuntimeException("wtf")
    r
    //scala.collection.JavaConversions.asList(children)
  }

  def add(item:MNode) {
    this.children =  item :: this.children
  }

  def setText(v:String) : Unit =  {
    //println("x" + this.x);

    pcs.firePropertyChange("text", this.text, v);
    this.text = v;
  }
}


object NodeHelper {
  import se.pearglans.Direction

  def getIncreaseInDirection(dir:Direction) : Int = {
      dir match {
          case Direction.RIGHT | Direction.DOWN =>  1
          case Direction.LEFT | Direction.UP => -1
        }
    }
    def translate(dir:Direction, node:MNode) : Unit = {

      node.pos match {
        case p:Point2DBean =>
          val inc = getIncreaseInDirection(dir)
          val read = getAcc(dir)
          val set = getEventAcc(dir)
          set(p,read(node) + inc * 20)
      }
    }
    def getAcc(dir:Direction) : (MNode) => Float = {
      dir match {
          case Direction.RIGHT | Direction.LEFT =>
            (g:MNode) => g.pos.x
          case Direction.DOWN | Direction.UP =>
            (g:MNode) => g.pos.y
        }
    }

    def getEventAcc(dir:Direction) : (Point2DBean,Float) => Unit = {
      dir match {
          case Direction.RIGHT | Direction.LEFT =>
            (g:Point2DBean,v:Float) => g.setX(v)
          case Direction.DOWN | Direction.UP =>
            (g:Point2DBean,v:Float) => g.setY(v)
        }
    }

  def findNearest(dir: Direction, target: MNode): MNode = {

    var min: Float = 10000.0f
    var nearest:Option[MNode] = None
    def isLess(a:MNode,b:MNode, g:MNode => Float) : Option[(MNode,Float)] = {
      val heur = g(a) - g(b)
      //println("heur" +heur)
      if(heur > 0 && heur < min) {
        Some((b,heur))
      } else None
    }



    val notItself = Tjo.flattened().filter(_.text != target.text)
    //println("yiiiiij" + notItself.size + " ")
    //notItself.foreach(println(_))
    notItself.foreach {
      n => {
        val (a,b) = dir match {
          case Direction.RIGHT | Direction.DOWN =>  (n,target)
          case Direction.LEFT | Direction.UP => (target,n)
        }
        val acc = getAcc(dir)
        isLess(a,b,acc) match {
          case Some((nn, nmin)) =>
             min = nmin
             nearest = Some(n)
          case _ =>
        }
      }
    }
    //println(min + " : " + nearest)
    nearest.getOrElse(null)
  }
}
