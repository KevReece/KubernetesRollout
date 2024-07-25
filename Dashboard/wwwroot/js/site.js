$(document).ready(function() {
    let nSquares = 64;
    let colourNodesEndpoint = 'http://localhost:8080/';
    let pendingResponseColour = 'black'

    function parseSquareColour(colourText) {
        let responseColours = ['green', 'blue'];
        if (colourText && (responseColours.includes(colourText) || colourText === pendingResponseColour)) {
            return colourText;
        }
        let failureColour = 'red';
        return failureColour;
    }

    function setSquareColour(index, colourText=null) {
        let colour = parseSquareColour(colourText);
        $('#square-' + index).css('background-color', colour);
    }

    function scheduleNextUpdate(index) {
        let timeout = 1000 + Math.floor(Math.random() * 1000);
        setTimeout(function() {
            updateSquare(index);
        }, timeout);
    }

    function updateSquare(index) {
        setSquareColour(index, pendingResponseColour);
        return $.get(colourNodesEndpoint)
            .done(function(response) {
                console.log('square' + index + ', response=' + response);
                setSquareColour(index, response);
            })
            .fail(function() {
                console.log('square' + index + ', fail');
                setSquareColour(index);
            })
            .always(function() {
                scheduleNextUpdate(index);
            });
    }
    
    function startSquareUpdates() {
        for (let index = 0; index < nSquares; index++) {
            scheduleNextUpdate(index);
        }
    }
    
    startSquareUpdates();
});
