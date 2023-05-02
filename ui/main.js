let option;

$(".options-button").click(function() {
    let depositBtn = $(this).data("option");
    option = depositBtn
    changeDetails(depositBtn);
    $("#bank-main-container").css("z-index","-1");
    $("#actions-warp").css("top","50%");
    $("#bank-main-container").css("pointer-events","none");
    $("#bank-main-container").css("filter","blur(2px)");
})

$(".transferBtn").click(function() {
    let depositBtn = $(this).data("option");
    option = depositBtn
    changeDetails(depositBtn);
    $("#bank-main-container").css("z-index","-1");
    $("#actions-warp-transfer").css("top","50%");
    $("#bank-main-container").css("pointer-events","none");
    $("#bank-main-container").css("filter","blur(2px)");
})

$("#acceptBtn").click(function() {
    let inputVal = parseInt($('input[name=input]').val());
    if(inputVal != ""){
        if(inputVal >= 0){
            $('input[name=input]').val("")
            $("#actions-warp").css("top","-22%");
            $("#bank-main-container").css("pointer-events","unset");
            $("#bank-main-container").css("filter","blur(0px)");
            setTimeout(() => {$("#bank-main-container").css("z-index","1")}, 400);
            $.post(`http://ip-banking/${option}`, JSON.stringify({inputVal}));
        }else{
        }
    }else{
    }
})

$("#acceptBtnT").click(function() {
    let inputVal = parseInt($('input[name=inputT]').val());
    let inputValID = parseInt($('input[name=inputI]').val());
    if(inputVal != "" && inputValID != ""){
        if(inputVal >= 0 && inputValID > 0){
            $('input[name=inputT]').val("")
            $('input[name=inputI]').val("")
            $("#actions-warp-transfer").css("top","-22%");
            $("#bank-main-container").css("pointer-events","unset");
            $("#bank-main-container").css("filter","blur(0px)");
            setTimeout(() => {$("#bank-main-container").css("z-index","1")}, 400);
            $.post(`http://ip-banking/transfer`, JSON.stringify({inputValID,inputVal}));
        }else{
        }
    }else{
    }
})

$(".transferBtn").click(function() {
    let depositBtn = $(this).data("option");
    option = depositBtn
    changeDetails(depositBtn);
    $("#bank-main-container").css("z-index","-1");
    $("#actions-warp-transfer").css("top","50%");
    $("#bank-main-container").css("pointer-events","none");
    $("#bank-main-container").css("filter","blur(2px)");
})

$("#cancelBtn").click(function() {
    $("#actions-warp").css("top","-22%");
    $("#bank-main-container").css("pointer-events","unset");
    $("#bank-main-container").css("filter","blur(0px)");
    setTimeout(() => {$("#bank-main-container").css("z-index","1")}, 400);
    $('input[name=input]').val("")
})

$("#cancelBtnT").click(function() {
    $("#actions-warp-transfer").css("top","-22%");
    $("#bank-main-container").css("pointer-events","unset");
    $("#bank-main-container").css("filter","blur(0px)");
    setTimeout(() => {$("#bank-main-container").css("z-index","1")}, 400);
    $('input[name=inputT]').val("")
    $('input[name=inputI]').val("")
})

$("#exit").click(function() {
    $("#bank-main-container").animate({ height: 'toggle', opacity: 'toggle' }, 'slow');
    $.post('http://ip-banking/close', JSON.stringify({}));
})

$(document).keydown(function(e) {
    // escape key pressed to close nui
    if (e.keyCode == 27) {
        $("#bank-main-container").animate({ height: 'toggle', opacity: 'toggle' }, 'slow');
        $.post('http://ip-banking/close', JSON.stringify({}));
    }
});


function changeDetails(data) {
    $("#actions-title").text(data + " " + "Money");
    $("#acceptBtn").text(data);
}
addEventListener("message", (e)=>{
    if(e.data.action){
        let bankAmount = parseInt(e.data.playerData.bank);
        let cashAmount = parseInt(e.data.playerData.cash);
        let id = parseInt(e.data.playerData.id);
        $("#bank-main-container").animate({ height: 'toggle', opacity: 'toggle' }, 'slow');
        $("#title-name").text(`Welcome back, ${e.data.playerData.firstname + " " + e.data.playerData.lastname}.`)
        $("#bankVelue").text(`${bankAmount.toLocaleString()}$`);
        $("#cashVelue").text(`${cashAmount.toLocaleString()}$`);
        $("#idVelue").text(`${id}`);
    }else if(e.data.updateBalance){
        let bankAmount = parseInt(e.data.playerData.bank);
        let cashAmount = parseInt(e.data.playerData.cash);
        let id = parseInt(e.data.playerData.id);
        $("#bankVelue").text(`${bankAmount.toLocaleString()}$`);
        $("#cashVelue").text(`${cashAmount.toLocaleString()}$`);
        $("#idVelue").text(`${id}`);
    }
})

function quickActionsWithdraw(amount){
    $.post("http://ip-banking/quickwit",JSON.stringify({amount:amount}));
}

function quickActionsDeposit(amount){
    $.post("http://ip-banking/quickdep",JSON.stringify({amount:amount}));
}

$(".quick-widthdraw2").click(function() {
    let amount = $(this).data("wit");
    quickActionsWithdraw(amount);
})

$(".quick-deposit2").click(function() {
    let amount = $(this).data("dep");
    quickActionsDeposit(amount);
})

$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();   
});