void setup() {
  size(500, 100);
  
  library myLibrary = createTestLibrary();

  myLibrary.printLibrary();
  
  myLibrary.getFormula(1).render();
  
  
/*  
  myLibrary.saveLibrary("TestXML.xml");
  
  library LoadLibrary = new library();
  println("Result = " + LoadLibrary.loadLibrary("TestXML.xml"));
  LoadLibrary.printLibrary();
*/  
}

library createStdLibrary() {
  library stdLibrary = new library("Std Library");
  // Create formulae
  // Add fomulae to library
  // Return the new library
  return stdLibrary;
}

library createTestLibrary() {
  library testLibrary = new library("Test Library");
  
  // Create test formulae
  formula ohmsLaw = new formula("Ohm's Law", new argument("V", "V"), new multiply(new argument("I", "A"), new argument("R", "ohms")));
  
  formula test = new formula("Test Fomula", new divide(new subtract(new argument("A", "a"), new argument("B", "b")), new argument("C", "c")), new addition(new argument("D", "d"), new argument("E", "e")), "Formula for testing purposes");
    
  formula test2 = new formula(new divide(new subtract(new argument("A", "a"), new argument("B", "b")), new argument("C", "c")), new bracket(new addition(new argument("D", "d"), new argument("E", "e"))));
  test2.setTitle("Test Two");
  test2.setDesc("Another test formula");
  node scalar = new argument("x", "units");
  test2.multiplyBy(scalar);
  
  // Add formulae to library
  testLibrary.addFormula(ohmsLaw);
  testLibrary.addFormula(test);
  testLibrary.addFormula(test2);
  
  // Return library
  return testLibrary;
}
