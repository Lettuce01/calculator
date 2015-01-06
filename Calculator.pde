void setup() {
  formula ohmsLaw = new formula(new argument("V", "V"), new multiply(new argument("I", "A"), new argument("R", "ohms")));
  node scalar = new argument("x", "units");
  //ohmsLaw.multiplyBy(scalar);
  ohmsLaw.stdPrint();
  
  formula test = new formula(new divide(new subtract(new argument("A", "a"), new argument("B", "b")), new argument("C", "c")), new addition(new argument("D", "d"), new argument("E", "e")));
  test.multiplyBy(scalar);
  test.stdPrint();
  
  formula test2 = new formula(new divide(new subtract(new argument("A", "a"), new argument("B", "b")), new argument("C", "c")), new bracket(new addition(new argument("D", "d"), new argument("E", "e"))));
  test2.multiplyBy(scalar);
  test2.stdPrint();
  
  library MyLibrary = new library("Craig's Library");
  MyLibrary.addFormula(ohmsLaw);
  MyLibrary.addFormula(test);
  MyLibrary.addFormula(test2);
  MyLibrary.printLibrary();
  MyLibrary.saveLibrary("TestXML.xml");
  
  library LoadLibrary = new library();
  println("Result = " + LoadLibrary.loadLibrary("TestXML.xml"));
  LoadLibrary.printLibrary();
  
}

//  formula.parse(String)
//  

abstract class node {
  protected renderer mRenderer;
  
  // Default behaviours:
  public node multiplyBy(node factor){
    return new multiply(factor, this);    
  }
  public node divideBy(node factor){
    return new divide(this, factor);
  }
  public node addOn(node addend){
    return new addition(this, addend);
  }
  public node subtract(node subend){
    return new subtract(this, subend);
  }
  
  public node create(XML XMLNode) {
    node newNode;
    String nodeType = XMLNode.getName();
    if (nodeType == "#text") {
      // discard
      newNode = null;
    } else if (nodeType == "Multiply") {
      newNode = new multiply(XMLNode);
    } else if (nodeType == "Divide") {
      newNode = new divide(XMLNode);
    } else if (nodeType == "Addition") {
      newNode = new addition(XMLNode);
    } else if (nodeType == "Subtract") {
      newNode = new subtract(XMLNode);
    } else if (nodeType == "Bracket") {
      newNode = new bracket(XMLNode);
    } else if (nodeType == "Argument") {
      newNode = new argument(XMLNode);
    } else {
      newNode = null;
      println("Unknown element found in Library: " + XMLNode.toString());
    }
    return newNode;
  }
  
  // Interface to be implemented by each subclass
  abstract void stdPrint();
  abstract XML createXML();
  abstract node passUpDenominators();
  
  abstract renderer prepareRender();
  abstract void render();
  
}

class formula extends node {
  // Should formula extend node?? Or just contain them??
  private node mLHS;
  private node mRHS;
 
  formula(node LHS, node RHS) {
    mLHS = LHS;
    mRHS = RHS;
  }
  formula(XML XMLFormula) {
    mLHS = null;
    mRHS = null;
    int nodeCount = 0;
    XML[] XMLNodes = XMLFormula.getChildren();
    for (XML thisNode: XMLNodes) {
      node newNode = create(thisNode);
      if (newNode != null) {
        nodeCount++;
        switch(nodeCount){
          case 1:
          mLHS = newNode;
          break;
          case 2:
          mRHS = newNode;
          break;
          default:
        }
      }
    }
    switch(nodeCount) {
      case 0:
      println("Error: Formula does not contain any valid elements.");
      break;
      case 1:
      println("Error: Formula only contains one node");
      //Should also make RHS equal a default argument
      break;
      case 2:
      // OK
      break;
      default:
      println("Warning: Formula contains more than 2 nodes");
    }
  }

  @Override
  public void stdPrint() {
    mLHS.stdPrint();
    print('=');
    mRHS.stdPrint();
    println();
  }
  
  @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return mRenderer.create_formula(mLHS, mRHS);
  } 

  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Formula");
    // Add name and other details via formula.setString("Name", formulaName);
    // Create and add children
    element.addChild(mLHS.createXML());
    element.addChild(mRHS.createXML());
    // Return XML element
    return element;
  }

  // formula applies modifications to both sides, to maintain equality
  @Override
  public node multiplyBy(node factor){
    mLHS = mLHS.multiplyBy(factor);
    mRHS = mRHS.multiplyBy(factor);
    return this;
  }
  @Override
  public node divideBy(node factor){
    mLHS = mLHS.divideBy(factor);
    mRHS = mRHS.divideBy(factor);
    return this;
  }
  @Override
  public node addOn(node addend){
    mLHS = mLHS.addOn(addend);
    mRHS = mRHS.addOn(addend);
    return this;
  }
  @Override
  public node subtract(node subend){
    mLHS = mLHS.subtract(subend);
    mRHS = mRHS.subtract(subend);
    return this;
  }
  
  @Override
  public node passUpDenominators() {
    node LHSDenominators = mLHS.passUpDenominators();
    node RHSDenominators = mRHS.passUpDenominators();
    if (LHSDenominators != null){
      mRHS.multiplyBy(LHSDenominators);
    }
    if (RHSDenominators != null){
      mLHS.multiplyBy(RHSDenominators);
    }
    return null;
  }
}



class argument extends node {
  private String mSymbol;
  private String mUnits;
  private boolean mValueKnown = false;
  private float mValue;
  
  argument(String symbol, String unit) {
    mSymbol = symbol;
    mUnits = unit;
    mValueKnown = false;
  }
  argument(String symbol, String unit, float value) {
    mSymbol = symbol;
    mUnits = unit;
    mValue = value;
    mValueKnown = true;
  }
  argument(XML XMLFunction) {
    mSymbol = XMLFunction.getString("Symbol", "@");
    mUnits = XMLFunction.getString("Units", "");
    if (XMLFunction.hasAttribute("Value")) {
      mValue = XMLFunction.getFloat("Value");
      mValueKnown = true;
    } else {
      mValueKnown = false;
    }
  }
  
  @Override
  public void stdPrint() {
    print(mSymbol);
  }
  @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return new text_renderer(mSymbol);
  }
  
  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Argument");
    // Add details
    element.setString("Symbol", mSymbol);
    element.setString("Units", mUnits);
    if (mValueKnown) {
      element.setFloat("Value", mValue);
    }
    // Return XML element
    return element;
  }

  @Override
  public node passUpDenominators(){
    return null;
  }
  

}

