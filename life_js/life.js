var life_width = 20;
var life_height = 20;
var game_of_life;

function create_game(element, width, height) {
    var totalSize = width * height;
    var grid = new Array(totalSize);
    for (i = 0; i < totalSize; i++) {
        if (i % width == 0 && i != 0) {
            element.append(document.createElement('br'));
        }
        grid[i] = document.createElement("div");
        grid[i].setAttribute('class', 'lifeDead');
        element.append(grid[i]);
    }
    return grid;
}

function load_random(game, totalSize) {
    for (i = 0; i < totalSize; i++) {
        if (Math.floor((Math.random()*2)) == 1) {
            game[i].setAttribute('class', 'lifeDead');
        } else {
            game[i].setAttribute('class', 'lifeAlive');
        }
    }
}

function load_Marco(game, totalSize) {
    
}

function run_game() {
    run_generation(game_of_life, life_width, life_height);
}

function run_generation(game, width, height) {
    var totalSize = width * height;
    var newGrid = new Array(totalSize);
    for (i = 0; i < totalSize; i++) {
        newGrid[i] = isAlive(game, width, height, i);
    }
    
    for (i = 0; i < totalSize; i++) {
        if (newGrid[i]) {
            game[i].setAttribute('class', 'lifeAlive');
        } else {
            game[i].setAttribute('class', 'lifeDead');
        }
    }
}

function isAlive(game, width, height, cell) {
    var state = game[cell].getAttribute('class') == 'lifeAlive';
    var neighbors = 0;
    var row = Math.floor(cell / width);
    var col = cell % width;
    if (col != 0) {
        if (row != 0) {
            if (game[cell - 1 - width].getAttribute('class') == 'lifeAlive')
                neighbors++;
        }
        if (game[cell - 1].getAttribute('class') == 'lifeAlive')
            neighbors++;
        if (row < height -1) {
            if (game[cell - 1 + width].getAttribute('class') == 'lifeAlive')
                neighbors++;
        }
    }
    if (row != 0) {
        if (game[cell - width].getAttribute('class') == 'lifeAlive')
            neighbors++;
    }
    if (row < height -1) {
        if (game[cell + width].getAttribute('class') == 'lifeAlive')
            neighbors++;
    }

    if (col < width - 1) {
        if (row != 0) {
            if (game[cell + 1 - width].getAttribute('class') == 'lifeAlive')
                neighbors++;
        }
        if (game[cell + 1].getAttribute('class') == 'lifeAlive')
            neighbors++;
        if (row < height - 1) {
            if (game[cell + 1 + width].getAttribute('class') == 'lifeAlive')
                neighbors++;
        }
    }

    return (neighbors == 3) || (state && neighbors == 2);
}


$(document).ready(function(){
    game_of_life = create_game($("#life"), life_width, life_height);
    load_random(game_of_life, life_width * life_height);
    window.setInterval("run_game()", 500);
    

$("#life").children().click(function() {

    $(this).removeClass('lifeDead');
    $(this).addClass('lifeAlive');
});

});














