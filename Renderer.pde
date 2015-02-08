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
    if (rType == RTYPE.VALUE) {
      text_renderer new_renderer = new text_renderer(value);
      new_renderer.mRType = rType;
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (VALUE) ~ ");
      return this;
    }
  }
  @Override
  public renderer create(int rType, renderer arg) {
    if (rType == RTYPE.BRACKET) {
      text_renderer new_renderer = new text_renderer();
      new_renderer.mRType = rType;
      new_renderer.mChild1 = arg;
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (BRACKET) ~ ");
      return this;
    }
    /*
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
    */
  }
  @Override
  public renderer create(int rType, renderer arg1, renderer arg2) {
    if ((rType == RTYPE.EQUATE) ||
        (rType == RTYPE.MINUS) ||
        (rType == RTYPE.PLUS) ||
        (rType == RTYPE.TIMES) ||
        (rType == RTYPE.DIVIDE) ||
        (rType == RTYPE.EXPONENT)) {
      text_renderer new_renderer = new text_renderer();
      new_renderer.mRType = rType;
      new_renderer.mChild1 = arg1;
      new_renderer.mChild2 = arg2;
      switch (rType) {
        case RTYPE.EQUATE:
          new_renderer.mText = "=";
          break;
        case RTYPE.MINUS:
          new_renderer.mText = "-";
          break;
        case RTYPE.PLUS:
          new_renderer.mText = "+";
          break;
        case RTYPE.TIMES:
          new_renderer.mText = "*";
          break;
        case RTYPE.DIVIDE:
          new_renderer.mText = "/";
          break;
        case RTYPE.EXPONENT:
          new_renderer.mText = "^";
          break;
        default:
          new_renderer.mText = "?";
      }
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (DUAL) ~ ");
      return this;
    }
    /*
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
    */
  }
  
  @Override
  public void render() {
    switch(mRType) {
      case RTYPE.VALUE:
        print(mText);
        break;
      case RTYPE.BRACKET:
        print("(");
        mChild1.render();
        print(")");
        break;
      case RTYPE.EQUATE:
      case RTYPE.MINUS:
      case RTYPE.PLUS:
      case RTYPE.TIMES:
      case RTYPE.DIVIDE:
      case RTYPE.EXPONENT:
        mChild1.render();
        print(mText);
        mChild2.render();
        break;
      default:
        print(" ~ Unknown Operator Type ~ ");
    }
    if (mRType == RTYPE.EQUATE) {
      print ("\n");
    }
  }
}

//-------------------------------------------------- graphic_renderer  
class graphic_renderer extends renderer {
  private String mText;
  //private int mXSize;
  //private int mYSize;
  
  graphic_renderer() {
    mText = "";
  }
  graphic_renderer(String text) {
    mText = text;
  }
  
  protected String getText() {
    return mText;
  }

  @Override
  public renderer create(int rType, String value) {
    return new graphic_renderer(value);
  }
  @Override
  public renderer create(int rType, renderer arg) {
    // Create single argument objects
    String retVal;
    graphic_renderer castArg = (graphic_renderer) arg;
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
    return new graphic_renderer(retVal);
  }
  @Override
  public renderer create(int rType, renderer arg1, renderer arg2) {
    // create dual argument objects
    String retVal;
    graphic_renderer castArg1 = (graphic_renderer) arg1;
    graphic_renderer castArg2 = (graphic_renderer) arg2;
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
    return new graphic_renderer(retVal);
  }
  
  @Override
  public void render() {
    text(mText, 10, 10);
  }
  
}

