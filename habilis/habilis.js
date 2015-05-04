/**
    Habilis is a simple Javascript of Scheme.
    author: Marco Montagna
*/

/** Define a Tokenizer class. */
function Tokenizer(string) {
    var tokens;
    var pointer;
    this.pointer = 0;
    this.tokens = string.trim().match(/([\'\"].*[\"\'])|(\<\=|\>\=|\(|\&|[\~\-\_\+\@\#\$\%\^\&\*\!\"\'\!a-z0-9\.\?\/\\]+|\||\)|\+|\-|\=|\%|\>|\<)/gi);
}
Tokenizer.prototype.parse = function() {
    if (this.tokens[this.pointer] == '(') {
        var array = [];
        this.pointer++;
        while (this.tokens[this.pointer] != ')') {
            if (this.tokens[this.pointer] == '(')
                array.push(this.parse());
            else
                array.push(this.tokens[this.pointer++]);
        }
        this.pointer++;
        return array;
    } else {
        return this.tokens[this.pointer++];
    }
}
Tokenizer.prototype.nextToken = function () {
    var token = this.parse();

    return token;
}
Tokenizer.prototype.hasNext = function () {
    return this.pointer < this.tokens.length;
}
/** End tokenizer class */

/** Define a Environment class. */
function Environment (parent) {
    var parent;
    var lookupTable;
    this.lookupTable = [];
    this.parent = parent;
}
Environment.prototype.set = function(symbol, value) {
    if (this.lookupTable[symbol] != null)
        return this.lookupTable[symbol] = value;
    else if (this.parent != null)
        return this.parent.set(symbol, value);
    else
        return HABILIS.SET_NOT_IN_SCOPE;
}
Environment.prototype.define = function(symbol, value) {
    this.lookupTable[symbol] = value;
    return value;
}
Environment.prototype.get = function(symbol) {
    if (this.lookupTable[symbol] != null)
        return this.lookupTable[symbol];
    else if (this.parent != null)
        return this.parent.get(symbol);
    else
        return HABILIS.NULL;
}
/** End Environment class. */

/** Define an Error class. */
function Error (value) {
    var value;
    this.value = value;
}
Error.prototype.toString = function() {
    return this.value;
}
/** End value. */

/** Define a Null class. */
function Null () {
}
Null.prototype.toString = function() {
    return "()";
}
/** End Null. */

/** Define a True class. */
function True () {
}
True.prototype.toString = function() {
    return "True";
}
/** True True. */

/** Define a False class. */
function False () {
}
False.prototype.toString = function() {
    return "False";
}
/** End False. */

/** Define a Function class */
function Function (name, parameters, body, prim, env) {
    var primitive;
    var name;
    var parameters;
    var body;
    var env;
    
    if (name != null)
        this.name = name;
    else
        this.name = "#<Closure>";
    this.parameters = parameters;
    this.body = body;
    this.prim = prim;
    this.env = env;
}
Function.prototype.isPrimitive = function () {
    return this.prim;
}
Function.prototype.apply = function (args, env) {
    if (this.isPrimitive())
       return this.body.apply(this, args);
    else {
        var activeEnv = new Environment(this.env);
        for (var i = 0; (i < args.length) && (i < this.parameters.length); i++) {
            activeEnv.define(this.parameters[i], eval(args[i], env));
        }
        return eval(this.body, activeEnv);
    }
}
Function.prototype.toString = function () {
    if (this.prim)
        return this.name;
    else
        return "#<Closure>";
}
/** End Function class. */

/** Exit the program with code. */
function exit() {
    store = 0;
    if (arguments.length > 0)
        store = arguments[0];
   readinput.close();
   process.exit(store);
}

/** Begin Primitive Function Definitions. */
function add() {
    var store = 0;
    for(var i = 0; i < arguments.length; i++) {
        store += arguments[i];
    }
    return store;
}
function sub() {
    var store;
    if (arguments.length < 1)
        throw new Error("Error: (-) too few arguments. Expected at least 1, got 0");
    if (arguments.length == 1)
        return -arguments[0];
    store = arguments[0];
    for(var i = 1; i < arguments.length; i++) {
        store -= arguments[i];
    }
    return store;
}
function mult() {
    var store = 1;
    for(var i = 0; i < arguments.length; i++) {
        store *= arguments[i];
    }
    return store;
}
function div() {
    var store;
    if (arguments.length < 1)
        throw new Error("Error: (/) too few arguments. Expected at least 1, got 0");
    if (arguments.length == 1)
        return 1 / arguments[0];

    store = arguments[0];
    for(var i = 1; i < arguments.length; i++) {
        store /= arguments[i];
    }
    return store;
}
function mod() {
    if (arguments.length != 2)
        throw new Error("Error: (%) wrong number of arguments. Expected 2, got " + (arguments.length));
    return  arguments[0] %  arguments[1];
}

function abs() {
    return  Math.abs(arguments[0]);
}

function less() {
    if (arguments.length != 2)
        throw new Error("Error: (<) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] < arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function greater() {
    if (arguments.length != 2)
        throw new Error("Error: (>) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] > arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function greaterEq() {
    if (arguments.length != 2)
        throw new Error("Error: (>=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] >= arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function lessEq() {
    if (arguments.length != 2)
        throw new Error("Error: (>=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] <= arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}
function eq() {
    if (arguments.length != 2)
        throw new Error("Error: (=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] == arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}
function cons() {
    if (arguments.length != 2)
        throw new Error("Error: (cons) wrong number of arguments. Expected 2, got " + (arguments.length));
    return [arguments[0], arguments[1]];
}

function car() {
    if (arguments.length != 1)
        throw new Error("Error: (car) wrong number of arguments. Expected 1, got " + (arguments.length));
    return arguments[0][0];
}

function cdr() {
    if (arguments.length != 1)
        throw new Error("Error: (cdr) wrong number of arguments. Expected 1, got " + (arguments.length));
    return arguments[0][1];
}

/** End Primitive Function Definitions. */

/** Define a Habilis class to store global constants and functions. */
function Habilis() {
    this.GLOBAL_ENVIRONMENT = new Environment();
    var NULL;
    var TRUE;
    var FALSE;
    var SET_NOT_IN_SCOPE;
    var GLOBAL_ENVIRONMENT;
    var FUNCTIONS;

    this.FUNCTIONS = {};
    this.NULL = new Null();
    this.TRUE = new True();
    this.FALSE = new False();
    this.SET_NOT_IN_SCOPE = new Error("Error: Set called on symbol not in scope");


    this.FUNCTIONS['define'] = new Function("#<Syntax define>", null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['set!'] = new Function("#<Syntax set!>", null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['begin'] = new Function("#<Syntax begin>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['lambda'] = new Function("#<Syntax lambda>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['if'] = new Function("#<Syntax if>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['cons'] = new Function("#<Function (cons)>", null, cons, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['car'] = new Function("#<Function (car)>", null, car, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['cdr'] = new Function("#<Function (cdr)>", null, cdr, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['exit'] = new Function("#<Function (exit)>", null, exit, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['+'] = new Function("#<Function (+)>",null, add, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['-'] = new Function("#<Function (-)>",null, sub, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['*'] = new Function("#<Function (*)>",null, mult, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['/'] = new Function("#<Function (/)>",null, div, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['%'] = new Function("#<Function (%)>",null, mod, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['abs'] = new Function("#<Function (abs)>",null, abs, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['<'] = new Function("#<Function (<)>",null, less, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['>'] = new Function("#<Function (>)>",null, greater, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['<='] = new Function("#<Function (<=)>",null, lessEq, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['>='] = new Function("#<Function (>=)>",null, greaterEq, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['='] = new Function("#<Function (=)>",null, eq, true, this.GLOBAL_ENVIRONMENT);
}
/** Returns true if token is a built in function. */
Habilis.prototype.primitive = function(token) {
    if (token instanceof Function && token.isPrimitive())
        return token;
    else {
        return this.FUNCTIONS[token];
    } 
}

/** Applies a primitive functions to tokens.
    Note token[0] will be the expression that
    evaluated to func. 
*/
Habilis.prototype.apply = function(func, tokens, env) {
    var args = [];
    for(var i = 1; i < tokens.length; i++) {
        args.push(eval(tokens[i], env));
    }

    return func.apply(args);
}
/** End Habilis. */

/** Returns true if token represents an integer. */
function isInt(token) {
    return !isNaN(Number(token)) && token.indexOf('.') == -1;
}

/** Returns true if token represents an floating point number. */
function isFloat(token) {
    return !isNaN(Number(token)) && token.indexOf('.') != -1;
}

/** Returns true if token represents a string. */
function isString(token) {
    if (typeof token == "string")
        return (token.charAt(0) == '"' && token.charAt(token.length - 1) == '"')
                || (token.charAt(0) == "'" && token.charAt(token.length - 1) == "'");
    return false;
}

/** Returns true if token starts a compound expression. */
function isCompound(token) {
    return Array.isArray(token);
}

/** Returns true if token starts an assignment expression. */
function isAssignment(token) {
    return token == HABILIS.FUNCTIONS['set!'];
}

/** Returns true if token starts an definition expression. */
function isDefinition(token) {
    return token == HABILIS.FUNCTIONS['define'];
}

/** Returns true if token starts a begin expression. */
function isBegin(token) {
    return token == HABILIS.FUNCTIONS['begin'];
}

/** Returns true if token starts a lambda expression. */
function isLambda(token) {
    return token == HABILIS.FUNCTIONS['lambda'];
}

/** Returns true if token starts a conditional expression. */
function isIf(token) {
    return token == HABILIS.FUNCTIONS['if'];
}

/** Returns true if token symbolic expression. */
function isVariable(token) {
    if (typeof token == "string")
        return token.match(/\<\=|\>|\=|\&|[\~\-\_\+\@\#\$\%\^\&\*\!\"\'\!a-z0-9\.\?\/\\]+|\||\+|\-|\=|\%|\>|\</gi) != null;
    else
        return false;
}

/** Returns true if token function. */
function isFunction(func) {
    return func instanceof Function;
}

function eval(token, env) {
    if (isCompound(token)) {
        var expr = eval(token[0], env);
        if (isIf(expr)) {
            if (eval(token[1], env) == HABILIS.TRUE) 
                return eval(token[2], env);
            else
                return eval(token[3], env);
        } else if (isBegin(expr)) {
            var statements = []
            for(var i = 1; i < token.length; i++) {
                statements.push( eval(token[i], env));
            }
            return statements[token.length - 2];
        } else if (isLambda(expr)) {
            var params = token[1];
            var body = token.slice(2);
            body.unshift(HABILIS.FUNCTIONS['begin']);
            return new Function (null, params, body, false, env)
        } else if (isAssignment(expr)) {
            return env.set(token[1], eval(token[2], env));
        } else if (isDefinition(expr)) {
            return env.define(token[1], eval(token[2], env));
        } else if (HABILIS.primitive(expr)) {
            return HABILIS.apply(expr, token, env);
        } else if (isFunction(expr)) {
            return expr.apply(token.slice(1), env);
        }
        return HABILIS.NULL;
    }
    if (isInt(token)) {
        return parseInt(token, 10);
    }
    if (isFloat(token)) {
        return parseFloat(token);
    }
    if (isString(token)) {
        return token.substring(1, token.length - 1);
    }
    if (isVariable(token)) {
        var result = env.get(token);
        if (result != HABILIS.NULL)
            return result;
    }
    if (HABILIS.primitive(token)) {
        return HABILIS.primitive(token);
    }
    return HABILIS.NULL;
}

/** Creates and returns a string representing value. */
function outputString(value, cancelParen) {
    if (Array.isArray(value)) {
        var open = "(";
        var close = ")";
        var seperator = ' ';
        if (cancelParen) {
            open = "";
            close = "";
        }
        if (value[1] == HABILIS.NULL)
            seperator = '';
        if (Array.isArray(value[1]) || value[1] == HABILIS.NULL ) {
            return open + value[0] + seperator + outputString(value[1], true) + close;
        } else {
            return open + value[0] + " . " + outputString(value[1]) + close;
        }
    } if (value == HABILIS.NULL && cancelParen) {
        return "";
    } else {
        return value.toString();
    }
}

/** Print the value to the standard output. */
function print(value) {
    console.log(outputString(value));
}

/** Begin Reading Input */

var readline = require('readline');

/** Create a readline object to get input from the user. */
var readinput = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

/** Clean up input */
function cleanLine(line) {
    return line;
}

var HABILIS = new Habilis();
var inputLine = '';
readinput.setPrompt("-> ");
readinput.prompt();
readinput.on('line', function (cmd) {
    inputLine += cmd + " ";
    if (inputLine.split("(").length == inputLine.split(")").length) {
        var tokens = new Tokenizer(cleanLine(inputLine));
        while (tokens.hasNext()) {
            print(eval(tokens.nextToken(), HABILIS.GLOBAL_ENVIRONMENT));
        }
        readinput.setPrompt("-> ");
        readinput.prompt();
        inputLine = "";
    }
});






















