package se.pearglans;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

public class JavaClass {
  private float amount = 99;

  public float getAmount() {
    return amount;
  }

  public void setAmount(float amount) {
    pcs.firePropertyChange("amount", this.amount, this.amount=amount);
    System.out.println("Changed amount to " + amount );
  }

  final PropertyChangeSupport pcs = new PropertyChangeSupport(this);

  public void addPropertyChangeListener( PropertyChangeListener listener) {
    pcs.addPropertyChangeListener(listener);
  }

  public void removePropertyChangeListener( PropertyChangeListener listener) {
    pcs.removePropertyChangeListener(listener);
  }
}