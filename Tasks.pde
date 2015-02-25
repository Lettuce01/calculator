/* Overall Goals
 *
 * Be able to rearrange individual formulae for a given argument
 * Solve a formula if enough of the arguments are given values
 * Have a (XML?) file from which multiple formulae are loaded
 * Be able to add new formulae and save them to the file
 * Be able to combine formulae to make more complex ones
 * Offer the user extra formulae or outcomes that can be derived from the current formula
 * Have a graphical interface to display formulae nicely
 * Clicking within the graphical interface can rearrange and combine formulae, or specify values for arguments
 */
 
/* Basic tasks
 *
 * Parse a formula from text
 */
 
/* Rearranging formulae
 *
 * Multiply through denominators
 * Expand brackets
 * Swap nodes to opposite sides of formulae
 * Simplify with respect to a specific argument/symbol
 */
 
/* Output interface
 * 
 * Each output interface should be able to be exchanged in place of others. It should be the only platform specific element.
 * The application should call 'render()' on any node.
 * That node should call 'prepare_render()' on itself, which calls the apropriate 'create_*' command from the renderer.
 * The originating node should then call 'show()' on the renderer.
 *
 * Setup:
 *   create_equation(LHS, RHS)
 *   create_fraction(numerator, denominator)
 *   create_exponential(base, exponent)
 *   create_bracket(content)
 *   create_subtext(base, subtext)
 *
 * Draw:
 *   show()                   Draws the output to the preset output stream (console or graphical display)
 *
 * Interact:
 *   return_size()            Returns x and y dimensions of the overall graphic
 *   return_clicks()          Returns the source object of any selected / clicked element 
 *   react_to_input(input)    Move cursor/selection/highlight based on arrow keys or mouse clicks
 */
 
