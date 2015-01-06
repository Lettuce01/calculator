abstract class operator extends node {
  protected node mArg1;
  protected node mArg2;
  operator(node arg1, node arg2) {
    mArg1 = arg1;
    mArg2 = arg2;
  }
  operator(XML XMLOperator) {
    mArg1 = null;
    mArg2 = null;
    int nodeCount = 0;
    XML[] XMLNodes = XMLOperator.getChildren();
    for (XML thisNode: XMLNodes) {
      node newNode = create(thisNode);
      if (newNode != null) {
        nodeCount++;
        switch(nodeCount){
          case 1:
          mArg1 = newNode;
          break;
          case 2:
          mArg2 = newNode;
          break;
          default:
        }
      }
    }
    switch(nodeCount) {
      case 0:
      println("Error: Operator does not contain any valid elements.");
      break;
      case 1:
      println("Error: Operator only contains one node");
      //Should also make Arg2 equal a default argument
      break;
      case 2:
      // OK
      break;
      default:
      println("Warning: Operator contains more than 2 nodes");
    }
  }
}

class bracket extends node {
  protected node mContent;
  bracket(node content) {
    mContent = content;
  }
  bracket(XML XMLFormula) {
    mContent = null;
    int nodeCount = 0;
    XML[] XMLNodes = XMLFormula.getChildren();
    for (XML thisNode: XMLNodes) {
      node newNode = create(thisNode);
      if (newNode != null) {
        nodeCount++;
        switch(nodeCount){
          case 1:
          mContent = newNode;
          break;
          default:
        }
      }
    }
    switch(nodeCount) {
      case 0:
      println("Error: Bracket does not contain any valid elements.");
      break;
      case 1:
      // OK
      break;
      default:
      println("Warning: Bracket contains more than 1 node");
    }
  }
  
  @Override
  public void stdPrint(){
    print('(');
    mContent.stdPrint();
    print(')');
  }
  @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return mRenderer.create_bracket(mContent);
  }

  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Bracket");
    // Create and add children
    element.addChild(mContent.createXML());
    // Return XML element
    return element;
  }
  
  @Override
  public node passUpDenominators(){
    return mContent.passUpDenominators();
  }
}

class multiply extends operator {
  multiply(node arg1, node arg2) {
    super(arg1, arg2);
  }
  multiply(XML XMLFunction) {
    super(XMLFunction);
  }
  
  @Override
  public void stdPrint() {
    mArg1.stdPrint();
    print('*');
    mArg2.stdPrint();
  }
  @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return new text_renderer("*");
  }
  
  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Multiply");
    // Create and add children
    element.addChild(mArg1.createXML());
    element.addChild(mArg2.createXML());
    // Return XML element
    return element;
  }
  
  @Override
  public node passUpDenominators(){
    node arg1Denominators = mArg1.passUpDenominators();
    node arg2Denominators = mArg1.passUpDenominators();
    if (arg1Denominators != null) {
      if (arg2Denominators != null) {
        return arg1Denominators.multiplyBy(arg2Denominators);
      } else {
        return arg1Denominators;
      }
    } else if (arg2Denominators != null) {
      return arg2Denominators;
    } else {
      return null;
    }
  }
}

class divide extends operator {
  divide(node arg1, node arg2) {
    super(arg1, arg2);
  }
  divide(XML XMLFunction) {
    super(XMLFunction);
  }
  
  @Override
  public void stdPrint() {
    mArg1.stdPrint();
    print('/');
    mArg2.stdPrint();
  }
    @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return mRenderer.create_fraction(mArg1, mArg2);
  }
  
  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Divide");
    // Create and add children
    element.addChild(mArg1.createXML());
    element.addChild(mArg2.createXML());
    // Return XML element
    return element;
  }
  
  @Override
  public node multiplyBy(node factor){
    if ((mArg1 instanceof addition) | (mArg1 instanceof subtract)) {
      mArg1 = new bracket(mArg1);
    }
    mArg1 = mArg1.multiplyBy(factor);
    return this;
  }
  @Override
  public node divideBy(node factor){
    if ((mArg2 instanceof addition) | (mArg2 instanceof subtract)) {
      mArg2 = new bracket(mArg2);
    }
    mArg2 = mArg2.multiplyBy(factor);
    return this;
  }
  
  @Override
  public node passUpDenominators(){
    node retval = mArg2;
    mArg2 = new argument("1", "1", 1.0);
    return retval;
  }
}


class addition extends operator {
  addition(node arg1, node arg2) {
    super(arg1, arg2);
  }
  addition(XML XMLFunction) {
    super(XMLFunction);
  }
  
  @Override
  public void stdPrint() {
    mArg1.stdPrint();
    print('+');
    mArg2.stdPrint();
  }
    @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return new text_renderer("+");
  }
  
  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Addition");
    // Create and add children
    element.addChild(mArg1.createXML());
    element.addChild(mArg2.createXML());
    // Return XML element
    return element;
  }

  @Override
  public node multiplyBy(node factor){
    mArg1 = mArg1.multiplyBy(factor);
    mArg2 = mArg2.multiplyBy(factor);
    return this;
  }
  @Override
  public node divideBy(node factor){
    mArg1 = mArg1.divideBy(factor);
    mArg2 = mArg2.divideBy(factor);
    return this;
  }
  
  @Override
  public node passUpDenominators(){
    node retval = null;
    node arg1Denominators = mArg1.passUpDenominators();
    node arg2Denominators = mArg2.passUpDenominators();
    if (arg1Denominators != null) {
      mArg2 = mArg2.multiplyBy(arg1Denominators);
      if (arg2Denominators != null) {
        mArg1 = mArg1.multiplyBy(arg2Denominators);
        return arg1Denominators.multiplyBy(arg2Denominators);
      } else {
        return arg1Denominators;
      }
    } else if (arg2Denominators != null) {
      mArg1 = mArg1.multiplyBy(arg2Denominators);
      return arg2Denominators;
    } else {
      return null;
    }
  }
}

class subtract extends operator {
  subtract(node arg1, node arg2) {
    super(arg1, arg2);
  }
  subtract(XML XMLFunction) {
    super(XMLFunction);
  }
  
  @Override
  public void stdPrint() {
    mArg1.stdPrint();
    print('-');
    mArg2.stdPrint();
  }
  @Override
  public void render() {
    mRenderer = new text_renderer();
    prepareRender().show();
  }
  @Override
  public renderer prepareRender() {
    return new text_renderer("-");
  }
  
  @Override
  public XML createXML() {
    // Create an XML element
    XML element = new XML("Subtract");
    // Create and add children
    element.addChild(mArg1.createXML());
    element.addChild(mArg2.createXML());
    // Return XML element
    return element;
  }

  @Override
  public node multiplyBy(node factor) {
    mArg1 = mArg1.multiplyBy(factor);
    mArg2 = mArg2.multiplyBy(factor);
    return this;
  }
  @Override
  public node divideBy(node factor){
    mArg1 = mArg1.divideBy(factor);
    mArg2 = mArg2.divideBy(factor);
    return this;
  }
  
  @Override
  public node passUpDenominators(){
    node retval = null;
    node arg1Denominators = mArg1.passUpDenominators();
    node arg2Denominators = mArg2.passUpDenominators();
    if (arg1Denominators != null) {
      mArg2 = mArg2.multiplyBy(arg1Denominators);
      if (arg2Denominators != null) {
        mArg1 = mArg1.multiplyBy(arg2Denominators);
        return arg1Denominators.multiplyBy(arg2Denominators);
      } else {
        return arg1Denominators;
      }
    } else if (arg2Denominators != null) {
      mArg1 = mArg1.multiplyBy(arg2Denominators);
      return arg2Denominators;
    } else {
      return null;
    }
  }
}


