abstract class renderer {
  
  abstract public void show();
  
  abstract protected renderer create_formula(node LHS, node RHD);
  abstract protected renderer create_fraction(node numerator, node denominator);
  abstract protected renderer create_exponential(node exponent);
  abstract protected renderer create_subtext(node subtext);
  abstract protected renderer create_bracket(node content);
}

class text_renderer extends renderer {
  private String mString;
  
  text_renderer() {
    mString = "";
  }
  text_renderer(String string) {
    mString = string;
  }
  
  protected String getText() {
    return mString;
  }
  
  public void show() {
    println(mString);
  }
  protected renderer create_formula(node LHS, node RHS) {
    return new text_renderer(LHS.prepareRender().getText() + "=" + RHS.prepareRender().getText());
  }
  protected renderer create_fraction(node numerator, node denominator) {
    mString = numerator.prepareRender().getText() + '/' + denominator.prepareRender().getText();
   return this;
  }
  protected renderer create_exponential(node exponent) {
    mString = '^' + exponent.prepareRender().getText();
    return this;
  }
  protected renderer create_subtext(node subtext) {
    mString = '{' + subtext.prepareRender().getText() + '}';
    return this;
  }
  protected renderer create_bracket(node content) {
    mString = '(' + content.prepareRender().getText() + ')';
    return this;
  }
}

