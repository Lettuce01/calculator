static class RTYPE {
  public static final int VALUE = 0;
  public static final int EQUATE = 1;
  public static final int MINUS = 2;
  public static final int PLUS = 3;
  public static final int TIMES = 4;
  public static final int DIVIDE = 5;
  public static final int EXPONENT = 6;
  public static final int BRACKET = 7;
}

abstract class renderer {
  protected renderer mChild1;
  protected renderer mChild2;
  protected int mRType;
  
  abstract public renderer create(int rType, String value);
  abstract public renderer create(int rType, renderer arg);
  abstract public renderer create(int rType, renderer arg1, renderer arg2);
  
  abstract public void render();
  
  //abstract public void show();
  
  //abstract protected renderer create_formula(node LHS, node RHD);
  //abstract protected renderer create_fraction(node numerator, node denominator);
  //abstract protected renderer create_exponential(node exponent);
  //abstract protected renderer create_subtext(node subtext);
  //abstract protected renderer create_bracket(node content);
}

class text_renderer extends renderer {
  private String mText;
  
  text_renderer() {
    mText = "";
  }
  text_renderer(String text) {
    mText = text;
  }
  
  protected String getText() {
    return mText;
  }

  @Override
  public renderer create(int rType, String value) {
    return new text_renderer(value);
  }
  @Override
  public renderer create(int rType, renderer arg) {
    // Create single argument objects
    String retVal;
    text_renderer castArg = (text_renderer) arg;
    switch (rType) {
      case RTYPE.VALUE:
        retVal = castArg.getText();
        break;
      case RTYPE.BRACKET:
        retVal = "(" + castArg.getText() + ")";
        break;
      default:
        retVal = "* Too few arguments *";
    }
    return new text_renderer(retVal);
  }
  @Override
  public renderer create(int rType, renderer arg1, renderer arg2) {
    // create dual argument objects
    String retVal;
    text_renderer castArg1 = (text_renderer) arg1;
    text_renderer castArg2 = (text_renderer) arg2;
    switch (rType) {
      case RTYPE.EQUATE:
        retVal = "=";
        break;
      case RTYPE.MINUS:
        retVal = "-";
        break;
      case RTYPE.PLUS:
        retVal = "+";
        break;
      case RTYPE.TIMES:
        retVal = "*";
        break;
      case RTYPE.DIVIDE:
        retVal = "/";
        break;
      case RTYPE.EXPONENT:
        retVal = "^";
        break;
      default:
        retVal = " ~ Unknown Operator ~ ";
    }
    retVal = castArg1.getText() + retVal + castArg2.getText();
    return new text_renderer(retVal);
  }
  
  @Override
  public void render() {
    println(mText);
  }
  
  /*
  @Override
  public void show() {
    println(mString);
  } */
  /*
  @Override
  protected renderer create_formula(node LHS, node RHS) {
    return new text_renderer(LHS.prepareRender().getText() + "=" + RHS.prepareRender().getText());
  } */
  /*
  @Override
  protected renderer create_fraction(node numerator, node denominator) {
    mString = numerator.prepareRender().getText() + '/' + denominator.prepareRender().getText();
   return this;
  } */
  /*
  @Override
  protected renderer create_exponential(node exponent) {
    mString = '^' + exponent.prepareRender().getText();
    return this;
  } */
  /*
  @Override
  protected renderer create_subtext(node subtext) {
    mString = '{' + subtext.prepareRender().getText() + '}';
    return this;
  } */
  /*
  @Override
  protected renderer create_bracket(node content) {
    mString = '(' + content.prepareRender().getText() + ')';
    return this;
  } */
}

