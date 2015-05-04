/**
    Habilis is a simple Javascript of a lisp/scheme like
    interpreter.
    author: Marco Montagna
*/

function isJSFunction(functionToCheck) {
 var getType = {};
 return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
}

/** Define a Delayed Value class */
function Delayed(thunk, tryNow) {
    var value;
    var lastTried = 0;
    var thunk;
    var retryTime = 2000;
    var retryLimit = 10;

    this.thunk = thunk;
}
Delayed.prototype.setValue = function(val) {
    this.value = val;
}
Delayed.prototype.value = function() {
    while (this.value == null && this.retryLimit > 0) {
        if (Date.now - this.lastTried > this.retryTime) {
            thunk.call(this, this);
            this.lastTried = Date.now();
            this.retryLimit -= 1;
        }
    }
    return this.value;
}

/** Define a Tokenizer class. */
function Tokenizer(string) {
    var tokens;
    var pointer;
    this.pointer = 0;



    this.tokens = string.trim().match(/([\'][^\']*[\'])|([\"][^\"]*[\"])|(\[|\]|\<\=|\>\=|\(|\&|[\~\-\_\+\@\#\$\%\=\^\&\*\!\"\'\!a-z0-9\.\?\/\\]+|\||\)|\+|\-|\=|\%|\>|\<)/gi);



    if (this.tokens == null)
            this.tokens = [];
}
Tokenizer.prototype.parse = function() {
    var tokenToReturn = [];

    if (this.tokens[this.pointer] == '(') {
        var array = [];
        this.pointer++;
        while (this.tokens[this.pointer] != ')') {
                array.push(this.parse());
        }
        this.pointer++;
        tokenToReturn =  array;
    } else {
        tokenToReturn = this.tokens[this.pointer++];
    }
    if (this.tokens[this.pointer] == "[") {
        this.pointer++;
        tokenToReturn = ["arrayAccess", tokenToReturn, this.nextToken()];
        this.pointer++;
    }

    return tokenToReturn;
}
Tokenizer.prototype.nextToken = function () {
    var token = this.parse();

    return token;
}
Tokenizer.prototype.hasNext = function () {
    return this.pointer < this.tokens.length;
}
Tokenizer.prototype.reset =     function () {
    this.pointer = 0;
}
Tokenizer.tokensToString = function (tokens, i) {
    if (i == null)
        i = 0;
    if (Array.isArray(tokens)) {
        if (i == 0) {
            return '(' + Tokenizer.tokensToString(tokens[i]) + Tokenizer.tokensToString(tokens, i + 1);
        } else if (i == tokens.length || tokens.length == 0) {
            return ')';
        } else {
            return " " + Tokenizer.tokensToString(tokens[i]) + Tokenizer.tokensToString(tokens, i + 1);
        }
    } else if (!tokens) {
        return "";
    } else {
        return tokens;
    }
}
/** End tokenizer class */

/** Define a Environment class. */
function Environment (parent, ltable) {
    var parent;
    var lookupTable;
    this.lookupTable = {};
    this.parent = parent;

}

Environment.prototype.toString = function() {
    return "<#Environment>";
}

Environment.prototype.set = function(symbol, value) {
    if (this.lookupTable[symbol] != null)
        return this.lookupTable[symbol] = value;
    else if (this.parent != null)
        return this.parent.set(symbol, value);
    else
        return HABILIS.SET_NOT_IN_SCOPE;
}

Environment.prototype.set = function(symbol, value) {
    var segments = symbol.split(".");
    if (segments.length > 1)
        return this.get(segments[0]).set(symbol.substring(symbol.indexOf(".") + 1), value);

    if (this.lookupTable["h_" + symbol] != null)
        return this.lookupTable["h_" + symbol] = value;
    else if (this.parent != null)
        return this.parent.set(symbol, value);
    else
        return HABILIS.SET_NOT_IN_SCOPE;
}

Environment.prototype.define = function(symbol, value) {
    var segments = symbol.split(".");
    if (segments.length > 1) {
        this.get(segments[0]).define(symbol.substring(symbol.indexOf(".") + 1), value);
    } else
        this.lookupTable["h_" + symbol] = value;
    return value;
}

Environment.prototype.get = function(symbol) {
    var segments = symbol.split(".");

    if (segments[0] == "this" && segments.length > 1) {
        return HABILIS.habilisThis.get(symbol.substring(symbol.indexOf(".") + 1));
    } else if (segments[0] == "this") {
        return HABILIS.habilisThis;
    }
    if (this.lookupTable["h_" + segments[0]] != null) {
        if (segments.length > 1) {
            HABILIS.habilisThis = this.lookupTable["h_" + segments[0]];
            return this.lookupTable["h_" + segments[0]].get(symbol.substring(symbol.indexOf(".") + 1));
        }
        return this.lookupTable["h_" + symbol];
    } else if (this.parent != null)
        return this.parent.get(symbol);
    else
        return ["unbound", symbol]; // HABILIS.NULL;
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
function H_Function (name, parameters, body, prim, env) {
    var primitive;
    var name;
    var parameters;
    var body;
    var env;
    
    if (name != null)
        this.name = name;
    else
        this.name = "#<Closure>";

    if (body && HABILIS)
        body.unshift(HABILIS.FUNCTIONS['begin']);

    this.parameters = parameters;
    this.body = body;
    this.prim = prim;
    this.env = new Environment(env);
}

H_Function.prototype.define = function(symbol, value) {
    return this.env.define(symbol, value);
}
H_Function.prototype.set = function(symbol, value) {
    return this.env.define(symbol, value);
}

H_Function.prototype.get = function(symbol, value) {
    return this.env.get(symbol);
}


H_Function.prototype.variableArity = function () {
    return (!Array.isArray(this.parameters) && !this.isPrimitive());
}

H_Function.prototype.isPrimitive = function () {
    return this.prim;
}
H_Function.prototype.apply = function (args, env) {
   if (!Array.isArray(args))
        args = [args];
   
    if (this.isPrimitive()) {
       return this.body.call(this, args, env);
    } else if (this.variableArity()) {
        var list = [];
        var handle = list;
        var activeEnv = new Environment(this.env);
        for (var i = 0; i < args.length - 1; i++) {
            list[0] = eval(args[i], env);
            list[1] = [];
            list = list[1]
        }
        list[0] = eval(args[args.length - 1], env);
        list[1] = HABILIS.NULL;
        activeEnv.define(this.parameters, handle);
        activeEnv.define("argc", args.length);
        return eval(this.body, activeEnv);
    } else {
        var activeEnv = new Environment(this.env);
        for (var i = 0; (i < args.length) && (i < this.parameters.length); i++) {
            activeEnv.define(this.parameters[i], eval(args[i], env));
        }
        activeEnv.define("argc", args.length);
        return eval(this.body, activeEnv);
    }
}
H_Function.prototype.toString = function () {
    if (this.prim)
        return this.name;
    else
        return "#<Closure>";
}
/** End Function class. */

/** Exit the program with code. */
function exit(arguments, env) {
    store = 0;
    if (arguments.length > 0)
        store = arguments[0];
   readinput.close();
   process.exit(store);
}

/** Begin Primitive Function Definitions. */
function add(arguments, env) {
    if (typeof arguments[0] == "string")
        var store = "";
    else
        var store = 0;
    for(var i = 0; i < arguments.length; i++) {
        store += arguments[i];
    }
    return store;
}
function sub(arguments, env) {
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
function mult(arguments, env) {
    var store = 1;
    for(var i = 0; i < arguments.length; i++) {
        store *= arguments[i];
    }
    return store;
}
function div(arguments, env) {
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
function mod(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (%) wrong number of arguments. Expected 2, got " + (arguments.length));
    return  arguments[0] %  arguments[1];
}

function abs(arguments, env) {
    return  Math.abs(arguments[0]);
}

function ceil(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (ceil) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.ceil(arguments[0]);
}

function floor(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (floor) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.floor(arguments[0]);
}

function less(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (<) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] < arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function greater(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (>) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] > arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function greaterEq(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (>=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] >= arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function lessEq(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (>=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] <= arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}
function eq(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] == arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function noteq(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (!=) wrong number of arguments. Expected 2, got " + (arguments.length));
    if (arguments[0] != arguments[1])
        return HABILIS.TRUE;
    else
        return HABILIS.FALSE;
}

function cons(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (cons) wrong number of arguments. Expected 2, got " + (arguments.length));
    return [arguments[0], arguments[1]];
}

function isPair(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (pair?) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Array.isArray(arguments[0]);
}


function setCdr(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (set-cdr!) wrong number of arguments. Expected 2, got " + (arguments.length));
    return arguments[0][1] =  arguments[1];
}

function setCar(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (set-car!) wrong number of arguments. Expected 2, got " + (arguments.length));
    return arguments[0][0] =  arguments[1];
}

function car(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (car) wrong number of arguments. Expected 1, got " + (arguments.length));
    if (isFunction(arguments[0])) {
        if (arguments[0].isPrimitive()) {
            return arguments[0];
        }
        return arguments[0].parameters;
    }

    return arguments[0][0];
}

function cdr(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (cdr) wrong number of arguments. Expected 1, got " + (arguments.length));
    if (isFunction(arguments[0])) {
        if (arguments[0].isPrimitive()) {
            return "Native Code";
        }
        return arguments[0].body;
    }
    return arguments[0][1];
}

function list(arguments, env) {
    var newList = [];
    var pointer = newList;

    for (var i = 0; i < arguments.length; i++) {
        newList[0] = arguments[i];
        if (i == arguments.length - 1) {
            newList[1] = HABILIS.NULL;
        } else {
            newList[1] = [];
            newList = newList[1];
        }
    }

    return pointer;
}



function append(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (append) wrong number of arguments. Expected at least 2, got " + (arguments.length));

    var newList = [];
    var pointer = newList;

    for (var i = 0; i < arguments.length; i++) {
        var list = arguments[i];
        if (!Array.isArray(list))
            list = [list, HABILIS.NULL];
        while (list != HABILIS.NULL)  {
            newList[0] = list[0];
            list = list[1];
            if (list == HABILIS.NULL && i == arguments.length - 1) {
                newList[1] = HABILIS.NULL;
            } else {
                newList[1] = [];
                newList = newList[1];
            }
            
        }
    }

    return pointer;
}

function appendBang(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (append!) wrong number of arguments. Expected at least 2, got " + (arguments.length));
    var newList = arguments[0]
    var pointer = newList;

    while (newList && newList[1] != HABILIS.NULL)  {
        newList = newList[1];
    }
    if (newList) {
        newList[1] = [];
        newList = newList[1];
    } else {
        newList = []
    }
    for (var i = 1; i < arguments.length; i++) {
        var list = arguments[i];
        if (!Array.isArray(list))
            list = [list, HABILIS.NULL];
        while (list != HABILIS.NULL)  {
            newList[0] = list[0];
            list = list[1];
            if (list == HABILIS.NULL && i == arguments.length - 1) {
                newList[1] = HABILIS.NULL;
            } else {
                newList[1] = [];
                newList = newList[1];
            }
            
        }
    }

    return pointer;
}

function contains(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (contains) wrong number of arguments. Expected at least 2, got " + (arguments.length));
        var index = 0;
        var list = arguments[1];
        if (!Array.isArray(list))
            list = [list, HABILIS.NULL];
        while (list != HABILIS.NULL)  {
            if (list[0] == arguments[0]) {
                return HABILIS.TRUE;
            }
            list = list[1];
            index++;
        }
    return HABILIS.FALSE;
}

function intersection(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (intersection) wrong number of arguments. Expected at least 2, got " + (arguments.length));
    var newList = [];
    var pointer = newList;
    var list = arguments[0];
    var list2 = arguments[1];
    while (list != HABILIS.NULL)  {
        if (contains([list[0], list2]) == HABILIS.TRUE) {
            newList[0] = list[0];
            newList[1] = HABILIS.NULL;
            newList = newList[1];
        }
        list = list[1];
    }

    return pointer;
}


function lispSetVar(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (listSetVar) wrong number of arguments. Expected 2, got " + (arguments.length));

    env.set(arguments[0], arguments[1]);
    return arguments[1];
}

function lispDefineVar(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (defineVar) wrong number of arguments. Expected 2, got " + (arguments.length));

    env.define(arguments[0], arguments[1]);
    return arguments[1];
}


function lispPrint(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (print) wrong number of arguments. Expected 1, got " + (arguments.length));
    print(arguments[0]);
    return HABILIS.NULL;
}

function lispMap(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (map) wrong number of arguments. Expected at least 2, got " + (arguments.length));
    var list = arguments[1];
    var newList = [];
    var pointer = newList;
    if (list == HABILIS.NULL)
        return HABILIS.NULL;


    var mapFunction = eval(arguments[0], env);
    while (list != HABILIS.NULL)  {
        newList[0] = mapFunction.apply([list[0]], env);
        list = list[1];
        if (list != HABILIS.NULL) {
        newList[1] = [];
        newList = newList[1];
        } else {
            newList[1] = HABILIS.NULL;
        }
        
    }
    return pointer;
}
function lispSin(arguments, env) {
    if (arguments.length < 1)
        throw new Error("Error: (sin) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.sin(arguments[0]);
}

function lispCos(arguments, env) {
    if (arguments.length < 1)
        throw new Error("Error: (cos) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.cos(arguments[0]);
}

function lispTan(arguments, env) {
    if (arguments.length < 1)
        throw new Error("Error: (tan) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.tan(arguments[0]);
}

function eExp(arguments, env) {
    if (arguments.length < 1)
        throw new Error("Error: (e) wrong number of arguments. Expected 2, got " + (arguments.length));
    return Math.exp(arguments[0]);
}

function lispSqrt(arguments, env) {
    if (arguments.length < 1)
        throw new Error("Error: (tan) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.sqrt(arguments[0]);
}

function lispLn(arguments, env) {
    if (arguments.length < 1)
        throw new Error("Error: (ln) wrong number of arguments. Expected 1, got " + (arguments.length));
    return Math.log(arguments[0]);
}

function lispReturn(arguments, env) {
    returnFlag = true;
    return arguments[0];
}

function lispReduce(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (reduce) wrong number of arguments. Expected at least 2, got " + (arguments.length));
    var list = arguments[1];
    var value = list[0];
    list = list[1];

    var reduceFunction = eval(arguments[0], env);
    while (list != HABILIS.NULL)  {
        value = reduceFunction.apply([value, list[0]], env);
        list = list[1];        
    }
    return value;
}

function lispMillis(arguments, env) {
    return Date.now();
}

function lispLoad(arguments, env, callBack) {
    if (arguments.length != 1)
        throw new Error("Error: (load) wrong number of arguments. Expected at least 1, got " + (arguments.length));
    $.ajaxSetup({ cache: false });
    var name = arguments[0];
    $.get(arguments[0], function(data){
        if (data.split("(").length == data.split(")").length) {
            var tokens = new Tokenizer(data);
            while (tokens.hasNext()) {
                token = tokens.nextToken();
                eval(token, HABILIS.GLOBAL_ENVIRONMENT);
            }
        } else {
            print("Unable to load: " + name);
        }
        callBack();
    });
}

function rand(arguments, env) {
    if (arguments.length == 1) {
       return Math.random()*arguments[0];
    } else  if (arguments.length == 2) {
        return (Math.random()*arguments[1])+arguments[0];
    } else  {
        return Math.random();
    }
}

function not(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (not) wrong number of arguments. Expected 1, got " + (arguments.length));
    if (HABILIS.TRUE == arguments[0])
        return HABILIS.FALSE;
    else
        return HABILIS.TRUE;
}

function lispSetTimeout(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (timeout) wrong number of arguments. Expected 2, got " + (arguments.length));
    var funcCall = [];
    funcCall.push(arguments[0]);//Putting arg[0] into arr calls it.
    return setTimeout(function() { eval(funcCall, env) }, arguments[1]);
}
function lispSetInterval(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (interval) wrong number of arguments. Expected 2, got " + (arguments.length));
    var funcCall = [];
    funcCall.push(arguments[0]);//Putting arg[0] into arr calls it.
    var temp =setInterval(function() { eval(funcCall, env) }, arguments[1]);
    HABILIS.addTimeOutHandle(temp);
    return temp;
}

function lispClearAllIntervals(arguments, env) {

    HABILIS.clearTimeOutHandles();
    return HABILIS.NULL;
}

function lispClearInterval(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (clearInterval) wrong number of arguments. Expected 1, got " + (arguments.length));

    return clearInterval(arguments[0]);
}

function newArray(arguments, env) {
    var temp = ["habilisArray"];
    for (var i = 0; i < arguments.length; i++)
        temp[i+1] = arguments[i];
    return temp;
}


function arraySet(arguments, env) {
    if (arguments.length != 3)
        throw new Error("Error: (arraySet) wrong number of arguments. Expected 3, got " + (arguments.length));
    return arguments[0][arguments[1] + 1] = arguments[2];
}

function habilisLength(arguments, env) {
    if (arguments.length != 1)
        throw new Error("Error: (array-length) wrong number of arguments. Expected 1, got " + (arguments.length));

    return arguments[0].length - 1;
}



function arrayAccess(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (arrayAccess) wrong number of arguments. Expected at least 2, got " + (arguments.length));

    if (arguments.length == 3 && (arguments[0].length > eval([arguments[2], arguments[1]], env) + 1)) {
        return arguments[0][eval([arguments[2], arguments[1]], env) + 1];
    } else if (arguments[0].length > arguments[1] + 1)
        return arguments[0][arguments[1] + 1];
    else
        return HABILIS.NULL;
}

function createHashMap(arguments, env) {
    var temp = {
                toString : function() {
                    return JSON.stringify(this);
                }};

    return temp;
}
function getHashMap(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (get-hashmap) wrong number of arguments. Expected 2, got " + (arguments.length));
    return arguments[0][arguments[1]];
}
function addHashMap(arguments, env) {
    if (arguments.length < 3)
        throw new Error("Error: (add-hashmap) wrong number of arguments. Expected 3, got " + (arguments.length));
    return arguments[0][arguments[1]] = arguments[2];
}
function deleteHashMap(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (delete-hashmap) wrong number of arguments. Expected 2, got " + (arguments.length));
    delete arguments[0][arguments[1]];
}

function lispGet(arguments, env) {
    if (arguments.length != 2)
        throw new Error("Error: (get) wrong number of arguments. Expected 2, got " + (arguments.length));

    return arguments[0][arguments[1]];
}

function lispPut(arguments, env) {
    if (arguments.length != 3)
        throw new Error("Error: (put) wrong number of arguments. Expected 3, got " + (arguments.length));
    arguments[0][arguments[1]] = arguments[2];

    return arguments[2];
}

function lispObject(arguments, env) {
    return new Environment (env);
}



function native(arguments, env) {
    var args = Array.prototype.slice.call(arguments, 1);
    var funcName = Array.prototype.slice.call(arguments, 0)[0];
    var context = window;
    var namespaces = funcName.split(".");
    var func = namespaces.pop();
    for (var i = 0; i < namespaces.length; i++) {
        context = context[namespaces[i]];
    }

    if(isJSFunction(context[func])) {
    return context[func].apply(null, args);
    } else {
        return context[func];
    }
}

function graphics(arguments, env) {
    var args = Array.prototype.slice.call(arguments, 1);

    if(isJSFunction(pjs[arguments[0]])) {
        return pjs[arguments[0]].apply(null, args);
    } else {
        return pjs[arguments[0]];
    }
}

/** Work in Progress
function listPost(arguments, env) {
    if (arguments.length < 2)
        throw new Error("Error: (post) wrong number of arguments. Expected at least 2, got " + (arguments.length));
    var thunk = function (value) {
        var delayValue= value;        
        $.ajax({
            type: "POST",
            url: arguments[0],
            data: '',
            success: function (returnedData) { delayValue.setValue(returnedData) },
        });
    }
    return new Delayed(thunk, tryNow);
}
/**


/** End Primitive Function Definitions. */

/** Define a Habilis class to store global constants and functions. */
function Habilis() {

    var NULL;
    var TRUE;
    var FALSE;
    var SET_NOT_IN_SCOPE;
    var GLOBAL_ENVIRONMENT;
    var FUNCTIONS;
    var TIMEOUT_HANDLES;
    this.GLOBAL_ENVIRONMENT = new Environment();
    this.GLOBAL_ENVIRONMENT.toString = function () {
        return "[#Global Env]";
    };
    this.FUNCTIONS = {};
    this.NULL = new Null();
    this.TRUE = new True();
    this.FALSE = new False();
    this.habilisThis = this.NULL;
    this.TIMEOUT_HANDLES = [];
    

    this.SET_NOT_IN_SCOPE = new Error("Error: Set called on symbol not in scope");


    this.FUNCTIONS['define'] = new H_Function("#<Syntax define>", null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['get'] = new H_Function("#<Function (get)>", null, lispGet, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['put'] = new H_Function("#<Function (put)>", null, lispPut, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['hashmap'] = new H_Function("#<Function (hashmap)>", null, createHashMap, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['get-hashmap'] = new H_Function("#<Function (get-hashmap)>", null, getHashMap, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['add-hashmap'] = new H_Function("#<Function (add-hashmap)>", null, addHashMap, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['delete-hashmap'] = new H_Function("#<Function (delete-hashmap)>", null, deleteHashMap, true, this.GLOBAL_ENVIRONMENT);




    this.FUNCTIONS['set!'] = new H_Function("#<Syntax set!>", null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['arrayAccess'] = new H_Function("#<Syntax arrayAccess>", null, arrayAccess, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['newArray'] = new H_Function("#<Syntax newArray>", null, newArray, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['array'] = new H_Function("#<Syntax newArray>", null, newArray, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['arraySet'] = new H_Function("#<Syntax arraySet!>", null, arraySet, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['set'] = new H_Function("#<Syntax arraySet!>", null, arraySet, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['array-length'] = new H_Function("#<Syntax array-length>", null, habilisLength, true, this.GLOBAL_ENVIRONMENT);


    this.FUNCTIONS['begin'] = new H_Function("#<Syntax begin>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['return'] = new H_Function("#<Syntax return>",null, lispReturn, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['let'] = new H_Function("#<Syntax let>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['lambda'] = new H_Function("#<Syntax lambda>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['if'] = new H_Function("#<Syntax if>",null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['native'] = new H_Function("#<Native Func>", null, native, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['interval'] = new H_Function("#<Native interval>", null, lispSetInterval, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['timeout'] = new H_Function("#<Native timeout>", null, lispSetTimeout, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['clearInterval'] = new H_Function("#<Native clearInterval>", null, lispClearInterval, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['clearIntervals'] = new H_Function("#<Native clearIntervals>", null, lispClearAllIntervals, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['graphics'] = new H_Function("#<Graphics Func>", null, graphics, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['print'] = new H_Function("#<Function (print)>", null, lispPrint, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['defineVar'] = new H_Function("#<Function (defineVar)>", null, lispDefineVar, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['object'] = new H_Function("#<Function (object)>", null, lispObject, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['rand'] = new H_Function("#<Function (rand)>", null, rand, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['setVar!'] = new H_Function("#<Function (setVar!)>", null, lispSetVar, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['map'] = new H_Function("#<Function (map)>", null, lispMap, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['reduce'] = new H_Function("#<Function (reduce)>", null, lispReduce, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['append'] = new H_Function("#<Function (append)>", null, append, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['list'] = new H_Function("#<Function (list)>", null, list, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['append!'] = new H_Function("#<Function (append!)>", null, appendBang, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['cons'] = new H_Function("#<Function (cons)>", null, cons, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['pair?'] = new H_Function("#<Function (pair?)>", null, isPair, true, this.GLOBAL_ENVIRONMENT);


    this.FUNCTIONS['car'] = new H_Function("#<Function (car)>", null, car, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['cdr'] = new H_Function("#<Function (cdr)>", null, cdr, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['set-car!'] = new H_Function("#<Function (set-car!)>", null, setCar, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['set-cdr!'] = new H_Function("#<Function (set-cdr!)>", null, setCdr, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['exit'] = new H_Function("#<Function (exit)>", null, exit, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['while'] = new H_Function("#<Syntax (while)>", null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['enum'] = new H_Function("#<Syntax (enum)>", null, null, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['for'] = new H_Function("#<Syntax (for)>", null, null, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['millis'] = new H_Function("#<Function (millis)>", null, lispMillis, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['+'] = new H_Function("#<Function (+)>",null, add, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['-'] = new H_Function("#<Function (-)>",null, sub, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['*'] = new H_Function("#<Function (*)>",null, mult, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['/'] = new H_Function("#<Function (/)>",null, div, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['%'] = new H_Function("#<Function (%)>",null, mod, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['abs'] = new H_Function("#<Function (abs)>",null, abs, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['<'] = new H_Function("#<Function (<)>",null, less, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['>'] = new H_Function("#<Function (>)>",null, greater, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['<='] = new H_Function("#<Function (<=)>",null, lessEq, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['>='] = new H_Function("#<Function (>=)>",null, greaterEq, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['='] = new H_Function("#<Function (=)>",null, eq, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['!='] = new H_Function("#<Function (!=)>",null, noteq, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['floor'] = new H_Function("#<Function (floor)>",null, floor, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['ceil'] = new H_Function("#<Function (ceil)>",null, ceil, true, this.GLOBAL_ENVIRONMENT);
    
    
    
    this.FUNCTIONS['not'] = new H_Function("#<Function (not)>",null, not, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['load'] = new H_Function("#<Function (load)>",null, lispLoad, true, this.GLOBAL_ENVIRONMENT);

    this.FUNCTIONS['e'] = new H_Function("#<Function (e)>",null, eExp, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['sin'] = new H_Function("#<Function (sin)>",null, lispSin, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['cos'] = new H_Function("#<Function (cos)>",null, lispCos, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['tan'] = new H_Function("#<Function (tan)>",null, lispTan, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['sqrt'] = new H_Function("#<Function (sqrt)>",null, lispSqrt, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['ln'] = new H_Function("#<Function (ln)>",null, lispLn, true, this.GLOBAL_ENVIRONMENT);



    this.FUNCTIONS['in'] = new H_Function("#<Function (in)>",null, contains, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['contains'] = new H_Function("#<Function (in)>",null, contains, true, this.GLOBAL_ENVIRONMENT);
    this.FUNCTIONS['intersect'] = new H_Function("#<Function (intersection)>",null, intersection, true, this.GLOBAL_ENVIRONMENT);


    
}


Habilis.prototype.addTimeOutHandle = function(handle) {
    this.TIMEOUT_HANDLES.push(handle);
}

Habilis.prototype.clearTimeOutHandles = function() {
    for (var i = 0; i < this.TIMEOUT_HANDLES.length; i++) {
        clearTimeout(this.TIMEOUT_HANDLES[i]);
    }
    this.TIMEOUT_HANDLES = [];
}


/** Returns true if token is a built in function. */
Habilis.prototype.primitive = function(token) {
    if (token instanceof H_Function && token.isPrimitive())
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
    return func.apply(args, env);
}
/** End Habilis. */

/** Returns true if token represents an integer. */
function isInt(token) {

    return typeof token === 'number' || (!isNaN(Number(token)) && token.indexOf('.') == -1);
}

/** Returns true if token represents an floating point number. */
function isFloat(token) {
    return (typeof token === 'number' && token.toString().indexOf('.') != -1) 
            || (!isNaN(Number(token)) && token.indexOf('.') != -1);
           
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

/** Returns true if token starts a let expression. */
function isLet(token) {
    return token == HABILIS.FUNCTIONS['let'];
}

/** Returns true if token starts a conditional expression. */
function isIf(token) {
    return token == HABILIS.FUNCTIONS['if'];
}

/** Returns true if token starts a return expression. */
function isReturn(token) {
    return token == HABILIS.FUNCTIONS['return'];
}

/** Returns true if token starts a for expression. */
function isFor(token) {
    return token == HABILIS.FUNCTIONS['for'];
}


/** Returns true if token starts a while expression. */
function isWhile(token) {
    return token == HABILIS.FUNCTIONS['while'];
}

/** Returns true if token starts an enum expression. */
function isEnum(token) {
    return token == HABILIS.FUNCTIONS['enum'];
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
    return func instanceof H_Function;
}
var returnFlag = false;
/** Standard Eval function. */
function eval(token, env) {
    if (isCompound(token)) {
        var expr = eval(token[0], env);
        if (isIf(expr)) {
            var temp = eval(token[1], env);
            if (temp != HABILIS.FALSE && temp != HABILIS.NULL) 
                return eval(token[2], env);
            else
                return eval(token[3], env);
        } else if (isFor(expr)) {
            var val = HABILIS.NULL;
            var popVal = env.get(token[1]);
            var handle = eval(token[2], env);
            if (handle[0] == "habilisArray") {
                for (var j = 1; j < handle.length; j++) {
                    env.define(token[1], handle[j]);
                    for(var i = 3; i < token.length; i++) {
                        val = eval(token[i], env);
                        if (returnFlag) {
                            returnFlag = false;
                            return val;                
                        }
                    }
                }
            } else {
                while (handle != HABILIS.NULL && handle) {
                    env.define(token[1], handle[0]);
                    for(var i = 3; i < token.length; i++) {
                        val = eval(token[i], env);
                        if (returnFlag) {
                            returnFlag = false;
                            return val;                
                        }
                    }
                    handle = handle[1];
                }
            }
            env.set(token[1], popVal);
            return val;
        } else if (isWhile(expr)) {
            var val = HABILIS.NULL;
            var temp = eval(token[1], env);
            while (temp != HABILIS.FALSE && temp != HABILIS.NULL) {
                for(var i = 2; i < token.length; i++) {
                    val = eval(token[i], env);
                    temp = eval(token[1], env);
                    if (returnFlag) {
                        return val;                
                    }
                }
            }
            return val;
        } else if (isEnum(expr)) {
            for(i = 0; i < token.length -1; i++) {
                env.define(token[i + 1], i);
            }

            return i;
        } else if (isBegin(expr)) {
            for(var i = 1; i < token.length - 1; i++) {
                var temp = eval(token[i], env)
                if (returnFlag) {
                    returnFlag = false;
                    return temp;                
                }
            }
            return eval(token[token.length - 1], env);
        } else if (isLet(expr)) {
            var list = token[1];
            var params = [];
            var values = [];
            for (var i = 0; i < list.length; i++) {
                params.push(list[i][0]);
                values.push(list[i][1]);
            }
            var body = token.slice(2);
            return (new H_Function (null, params, body, false, env)).apply(values, env);
        }  else if (isLambda(expr)) {
            var params = token[1];
            var body = token.slice(2);
            return new H_Function (null, params, body, false, env);
        } else if (isAssignment(expr)) {
            return env.set(token[1], eval(token[2], env));
        } else if (isDefinition(expr)) {
            return env.define(token[1], eval(token[2], env));
        } else if (HABILIS.primitive(expr)) {
            return HABILIS.apply(expr, token, env);
        } else if (isFunction(expr)) {
            return expr.apply(token.slice(1), env);
        } else if (token.length > 0) {
            return token; //Must already be a list. 
        } else {
            return HABILIS.NULL;
        }
    }
    if (isInt(token)) {
        return parseInt(token);
    }
    if (isFloat(token)) {
        return parseFloat(token);
    }
    if (isString(token)) {
        return token.substring(1, token.length - 1);
    }

    var result = [];
    if (isVariable(token)) {
        result = env.get(token);
        if (!Array.isArray(result))
            return result;
        if (result[0] != "unbound")
            return result;
    }
    if (HABILIS.primitive(token)) {
        return HABILIS.primitive(token);
    }
    if (isFunction(token)) {
        return token;
    }
    if (result[0] == "unbound") {
    console.log("UNBOUND GOING TO " + result[1]);
        return result[1];

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
            return open + outputString(value[0]) + seperator + outputString(value[1], true) + close;
        } else {
            return open + outputString(value[0]) + " . " + outputString(value[1]) + close;
        }
    } if (value == HABILIS.NULL && cancelParen) {
        return "";
    } else if (value || value == 0) {
        return value.toString();
    } else {
        return "";
    }
}

/** Print the expr to the standard output. */
function printExpr(expr, time) {
    if (time != null)
        pjs.println("=> " + outputString(expr) + "      Executed in " + time + " ms.");
    else
        pjs.println("=> " + outputString(expr));
}

/** Print the standard output. */
function print(value) {
    pjs.println(value);
}

/** Print the standard output. */
function printLine( value) {
    pjs.println(value);
}

/** Print the input line. */
function printTokens(value) {
    pjs.print('-> ' + Tokenizer.tokensToString(value));
}

/** Clean up input */
function cleanLine(line) {
    return line.replace(/^->/, '');
}

/** Encode HTML Tags for display. */
function encodeTags(val) {
    return jQuery('<div/>').text(val).html();
}

/** Move caret to the last char. */
function moveCaretToEnd(el) {
    if (typeof el.selectionStart == "number") {
        el.selectionStart = el.selectionEnd = el.value.length;
    } else if (typeof el.createTextRange != "undefined") {
        el.focus();
        var range = el.createTextRange();
        range.collapse(false);
        range.select();
    }
}

/** Reset the prompt. */
function prompt() {
    $('#habilisInput').val('-> ');
    $('#habilisInput').focus();
    moveCaretToEnd($('#habilisInput'));
}


function save_habilis() {
        localStorage.setItem('habilis', JSON.stringify(HABILIS.GLOBAL_ENVIRONMENT.lookupTable));
}

function update_habilis() {
        if (localStorage.getItem('habilis')) {
            HABILIS.GLOBAL_ENVIRONMENT.lookupTable = JSON.parse(localStorage.getItem('habilis'));
        }
}


function getURLParameter(name) {
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}

/** Begin Program */



    var HABILIS;
    var inputLine = '';
    var pjs;
    var inputs;
    var inputPointer = 0;

var currentMousePos = {};


$(document).ready(function () {
    var allowAction = true;
    jQuery(document).keydown(function(e){
        if (e.keyCode == 16) {
            allowAction =  false;
            e.preventDefault();
        }
    });

    jQuery(document).keyup( function(e){
        if (e.keyCode == 16) {
            allowAction =  true;
            e.preventDefault();
        }
    });

    /** Setup Processing stuff. */

    pjs = new Processing("processing-canvas");
    pjs.setup = function() {
        pjs.size($("#processing-canvas").width(),
            $("#processing-canvas").height(), pjs.P3D);
        pjs.noLoop();
    }

    pjs.setup();
    pjs.println("Habilis");


    /** End Setup Processing stuff. */
	
	jQuery(document).mousemove(function(event) {
	        currentMousePos.x = event.pageX;
	        currentMousePos.y = event.pageY;
	    });

    var textareas = document.getElementsByTagName('textarea');
    var count = textareas.length;
    for(i=0;i<count;i++){
        textareas[i].onkeydown = function(e){

            if ((e.keyCode==38 || event.which==38) && allowAction) { //UP
                e.preventDefault();
                if ((inputPointer - 1) >= 0) {
                    var s = this.selectionStart;
                    inputPointer -= 1;
                    this.value = "-> " + inputs[inputPointer];
                    this.selectionEnd = inputs[inputPointer].length + 3;
                }
            }
            if ((e.keyCode==40 || event.which==40) && allowAction) { //DOWN
                e.preventDefault();
                if (inputPointer < (inputs.length - 1)) {
                    var s = this.selectionStart;
                    inputPointer += 1;
                    this.value = "-> " + inputs[inputPointer];
                    this.selectionEnd = inputs[inputPointer].length + 3;
                } else if (inputPointer == (inputs.length - 1)) {
                    var s = this.selectionStart;
                    inputPointer += 1;
                    this.value = "-> ";
                    this.selectionEnd = 3;
                }
            }
            if(e.keyCode==9 || event.which==9){
                e.preventDefault();
                var s = this.selectionStart;
                this.value = this.value.substring(0,this.selectionStart) + "\t" + this.value.substring(this.selectionEnd);
                this.selectionEnd = s+1; 
            }
        }
    }

    inputs = [];
    HABILIS = new Habilis();
    lispLoad(['startup.scm'], HABILIS.GLOBAL_ENVIRONMENT, function () {
        if (getURLParameter("data") != "null") {
            console.log("Data: " + getURLParameter("data"));
            $('#habilisInput').val($('#habilisInput').val() + getURLParameter("data"));
            var e = jQuery.Event("keydown");
            e.which = 13; 
            $('#habilisInput').trigger(e);
        } else {
            $('#habilisInput').val($('#habilisInput').val() + " ");
        }
    });

    prompt();
    var waiting = false;
    $('#habilisInput').keydown(function(e) {
        if (e.which == 13 && allowAction) {
            inputLine = cleanLine($(this).val() + " ");
            if (inputLine.split("(").length == inputLine.split(")").length) {
                e.preventDefault();
                var tokens = new Tokenizer(inputLine);
                inputs.push(inputLine.trim());
                var token;
                while (tokens.hasNext()) {
                    try {
                    token = tokens.nextToken();
                        var time = Date.now();
                        printTokens(token);
                        var temp = eval(token, HABILIS.GLOBAL_ENVIRONMENT);
                        var deltaTime = Date.now() - time;
                        printExpr(temp, deltaTime);
                    } catch (err) {
                        printExpr("Native Error: " + err);
                    }
                }
                inputLine = "";
                prompt();
                inputPointer = inputs.length;
                returnFlag = false;
            } else if (inputLine.split("(").length < inputLine.split(")").length) {
                inputLine = "";
                prompt();
            }
        
        }
    });


});






















