// -------------------------------------------------- node (abstract)
abstract class node {
  protected renderer mRenderer;
  
  // Default behaviours:
  public node multiplyBy(node factor){             // node:multiplyBy
    return new multiply(factor, this);    
  }
  public node divideBy(node factor){               // node:divideBy
    return new divide(this, factor);
  }
  public node addOn(node addend){                  // node:addOn
    return new addition(this, addend);
  }
  public node subtract(node subend){               // node:subtract
    return new subtract(this, subend);
  }
  
  public node create(XML XMLNode) {                // node:create
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
  abstract void stdPrint();                        // node:stdPrint (abstract)
  abstract XML createXML();                        // node:createXML (abstract)
  abstract node passUpDenominators();              // node:passUpDenominators (abstract)
  
  public void setRenderer(renderer r) {            // node:setRenderer
    mRenderer = r;
  }
  public void render() {                           // node:render
    if (mRenderer == null) {
      // Default renderer is the text_renderer
      mRenderer = new text_renderer();
    }
    prepareRender(mRenderer).render();
  }
  abstract public renderer prepareRender(renderer r);    // node:prepareRender (abstract)
} // node


// -------------------------------------------------- argument
class argument extends node {
  private String mSymbol;
  private String mUnits;
  private boolean mValueKnown = false;
  private float mValue;
  
  argument(String symbol, String unit) {           // argument:contructor
    mSymbol = symbol;
    mUnits = unit;
    mValueKnown = false;
  }
  argument(String symbol, String unit, float value) {      // argument:constructor
    mSymbol = symbol;
    mUnits = unit;
    mValue = value;
    mValueKnown = true;
  }
  argument(XML XMLFunction) {                      // argument:constructor
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
  public void stdPrint() {                         // argument:stdPrint
    print(mSymbol);
  }
  
  @Override
  public XML createXML() {                         // argument:createXML
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
  public node passUpDenominators(){                // argument:passUpDenominator
    return null;
  }
  
  @Override
  public renderer prepareRender(renderer r) {      // argument:prepareRender
    return r.create(RTYPE.VALUE, mSymbol);
  } 

} // argument


// -------------------------------------------------- formula
class formula extends node {
  // Should formula extend node?? Or just contain them??
  private node mLHS;
  private node mRHS;
  private String mTitle = "";
  private String mDescription = "";
 
  formula(node LHS, node RHS) {                    // formula:constructor
    mLHS = LHS;
    mRHS = RHS;
  }
  formula(String title, node LHS, node RHS) {      // formula:constructor
    mTitle = title;
    mLHS = LHS;
    mRHS = RHS;
  }
  formula(String title, node LHS, node RHS, String description) {    // formula:constructor
    mTitle = title;
    mLHS = LHS;
    mRHS = RHS;
    mDescription = description;
  }
  formula(XML XMLFormula) {                        // formula:constructor
    mLHS = null;
    mRHS = null;
    int nodeCount = 0;
    if (XMLFormula.hasAttribute("Title")) {
      mTitle = XMLFormula.getString("Title");
    }
    if (XMLFormula.hasAttribute("Description")) {
      mDescription = XMLFormula.getString("Description");
    }
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
  public void stdPrint() {                         // formula:stdPrint
    mLHS.stdPrint();
    print('=');
    mRHS.stdPrint();
    println();
  }

  public String getTitle() { return mTitle; }
  public void setTitle(String title) { mTitle = title; }
  public String getDesc() { return mDescription; }
  public void setDesc(String description) { mDescription = description; } 

  @Override
  public XML createXML() {                         // formula:createXML
    // Create an XML element
    XML element = new XML("Formula");
    // Add name and other details
    element.setString("Title", mTitle);
    element.setString("Description", mDescription);
    // Create and add children
    element.addChild(mLHS.createXML());
    element.addChild(mRHS.createXML());
    // Return XML element
    return element;
  }

  // formula applies modifications to both sides, to maintain equality
  @Override
  public node multiplyBy(node factor){             // formula:multiplyBy
    mLHS = mLHS.multiplyBy(factor);
    mRHS = mRHS.multiplyBy(factor);
    return this;
  }
  @Override
  public node divideBy(node factor){               // formula:divideBy
    mLHS = mLHS.divideBy(factor);
    mRHS = mRHS.divideBy(factor);
    return this;
  }
  @Override
  public node addOn(node addend){                  // formula:addOn
    mLHS = mLHS.addOn(addend);
    mRHS = mRHS.addOn(addend);
    return this;
  }
  @Override
  public node subtract(node subend){               // formula:subtract
    mLHS = mLHS.subtract(subend);
    mRHS = mRHS.subtract(subend);
    return this;
  }
  
  @Override
  public node passUpDenominators() {               // formula:passUpDenominators
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
  
  @Override
  public renderer prepareRender(renderer r) {        // formula:prepareRender
    return r.create(RTYPE.EQUATE, mLHS.prepareRender(r), mRHS.prepareRender(r));
  } 
  
} // formula



