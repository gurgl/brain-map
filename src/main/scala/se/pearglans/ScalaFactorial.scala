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

  private var root:MNode = Tjo.model
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
    target match {
      case null => root = item
      case _ => target.add(item) 
    }
    println("ACTION : ADDING NODE root " + target )
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



/*
object Direction extends Enumeration {
      type Direction = Value
      val LEFT, RIGHT, UP, DOWN = Value
    }
*/


trait ScalaToJavaFX {
    def updateFact(number:String)
    def updateTree(node:MNode)
}