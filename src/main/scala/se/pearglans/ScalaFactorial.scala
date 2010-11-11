package se.pearglans

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-okt-04
 * Time: 14:04:16
 * To change this template use File | Settings | File Templates.
 */


// JavaFX/Java Interface (...\javafx-sdk1.2.3\lib\desktop\javafx-common.jar)
import javafx.async.RunnableFuture
import reflect.{BeanProperty, BeanInfo}
// JavaFx project JavaFXScala
import se.pearglans.ScalaToJavaFX

final class ScalaEntry(private val fx: ScalaToJavaFX) extends RunnableFuture {

  private var fact: Factorial = null

  private var root:MNode = null
  // JavaFX Interface RunnableFuture
  def run: Unit = {
    fact = new Factorial {
      protected def value(i: BigInt) {
        Thread.sleep(500)              // to simulate a long lasting operation
        fx.updateFact(i.toString)
      }
    }
    fact.start
  }

  def addNode(item:MNode, target:MNode) {
    root match {
      case null => root = item
      case _ => target.add(item) 
    }
    fx.updateTree(target)
  }

  // Called from within JavaFXScalaBridge
  def calcFact(i: Int) {
    fact ! i              // sends message of type Int to Actor fact
  }
  def closeScala {
    fact = null
  }
}
 
import scala.actors.Actor
import actors.Actor._
import math.BigInt

object Tjo {

  def getModel : MNode = {
    println("woo")
    val r = new MNode(new Point2D(50,50),"tja")
    val child11 = new MNode(new Point2D(150,50),"tja2")
    val child12 = new MNode(new Point2D(50,150),"tja3")
    val child21 = new MNode(new Point2D(150,150),"tja4")
    r.children = List(child11,child12)
    child12.children = List(child21)
    println("Tjing" + r)
    r
  }
  
}
protected abstract class Factorial() extends Actor {

  override def act() = {
    loop {
      react {
        case i: Int => calcFactorial(i) // own thread, not on JavaFX-EDT !
      }
    }
  }

  private def calcFactorial(i: Int): Unit = {
    def fact(i: BigInt, accumulator: BigInt): BigInt = i match {
      case _ if i == 1 => accumulator
      case _ => fact(i - 1, i * accumulator)
    }
    value(fact(i, 1))
  }
  // Abstract method
  protected def value(i: BigInt)
}

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

trait HasPropertyChangeListener {

  val pcs:PropertyChangeSupport  = new PropertyChangeSupport(this)
  
  def addPropertyChangeListener( listener:PropertyChangeListener ) {
    pcs.addPropertyChangeListener(listener)
  }

  def removePropertyChangeListener( listener:PropertyChangeListener ) {
    pcs.removePropertyChangeListener(listener)
  }
}

//@BeanInfo
class Point2D(var x:Float, var y:Float) {
  
}
//
class Point2DBean(_x:Float,_y:Float) extends Point2D(_x,_y) with HasPropertyChangeListener {

  def setX(v:Float) : Unit =  {
    //println("x" + this.x);

    pcs.firePropertyChange("x", this.x, v);
    this.x = v;
  }
  def setY(v:Float) : Unit =  {


    //println("y");
    pcs.firePropertyChange("y", this.y, v);
    this.y = v;
  }
  def getX = x
  def getY = y

  /*override def x_$eq(v:Float) : Unit =  {
    pcs.firePropertyChange("x", this.x, this.x=v);
  }
  */
}


case class MNode(@BeanProperty val pos:Point2DBean, var text:String) extends HasPropertyChangeListener {
  //List[MNode]
  //def this() = this(Nil,null)
  //def this(p:Point2D) = this(Nil,p)

  def this(p:Point2D,t:String) = this(new Point2DBean(p.x,p.y),t)
  
  var children:List[MNode] = Nil

  import scala.collection.JavaConversions._

  def getChildren : java.util.List[MNode] = {
    val r = asList(children)
    println(children.size)
    if(r == null)
      throw new RuntimeException("wtf")
    r
    //scala.collection.JavaConversions.asList(children)
  }

  def add(item:MNode) {
    item.children =  item :: this.children     
  }

  def setText(v:String) : Unit =  {
    //println("x" + this.x);

    pcs.firePropertyChange("text", this.text, v);
    this.text = v;
  }

}


trait ScalaToJavaFX {
    def updateFact(number:String)
    def updateTree(node:MNode)
}