package se.pearglans

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-nov-30
 * Time: 16:23:17
 * To change this template use File | Settings | File Templates.
 */


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
case class Point2DBean(_x:Float,_y:Float) extends Point2D(_x,_y) with HasPropertyChangeListener {

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
