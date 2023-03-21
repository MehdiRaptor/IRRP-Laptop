let cartTotalPrice =0;
let data= {};
$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "open"){
            if(typeof event.data.data == "object") {
                $('#macbook').fadeIn();
                $('.userScreen').fadeIn();
                data = event.data.data;
                loadShit();
            } else {
                $('#macbook').fadeIn();
                $('.noPerm').fadeIn();
            }
        } else if (event.data.type == 'notification') {
            switch (event.data.message.type) {
                case 'success':
                    toastr.success(event.data.message.content,event.data.message.header,{timeOut: 8000});
                    break;
                case 'warn':
                    toastr.warning(event.data.message.content,event.data.message.header,{timeOut: 8000});
                    break;
                default:
                    toastr.danger(event.data.message.content,event.data.message.header,{timeOut: 8000});
                    break;
            }
        } else if (event.data.type == 'clearCart') {
            cart = {};
            syncCart();
        }
    });
});

// var data;
let cart = {};
let template = $('.templateRow').html();
let cartTemplate = $('.cartTemplateRow').html();
function loadShit() {
    $('.templateRow').html('');
    $('.cartTemplateRow').html('');
    for (const kee in data.weapons) {
        if (data.weapons.hasOwnProperty(kee)) {
            let item={};
            Object.assign(item, data.weapons[kee]);
            item.price = thousandSeparator(item.price);
            item.key = kee;
            item.time = '30m';
            $('.templateRow').append(Mustache.render(template, item));
        }
    }
    syncCart();
}
function syncCart(){
    $('.cartTemplateRow').html('');
    let totalPrice = 0;
    for (const keh in cart) {
        if (cart.hasOwnProperty(keh)) {
            let cItem = cart[keh];
            let item = {};
            Object.assign(item,data.weapons[keh]);
            item.amount = cItem;
            item.key = keh;
            totalPrice += Math.floor(item.price) * Math.floor(item.amount); // inja moheme
            item.price = thousandSeparator(item.price);
            $('.cartTemplateRow').append(Mustache.render(cartTemplate, item));
        }
    }
    $('.totalCartPrice').text(thousandSeparator(totalPrice)); // inja moheme 
    cartTotalPrice = totalPrice;
    if(Object.size(cart) < 1 ) { $('.cartCard').hide(); } else { $('.cartCard').fadeIn(); }
}
function addToCart(elm) {
    let key = elm.attr('ref');
    let val = Number(elm.parent().find('input[name="count"]').val());
    console.log(val);
    if(val>0)
    {
        if(!cart[key])
            cart[key] = 0;
        if(Number(elm.parent().find('input[name="count"]').attr('max')) > Number(cart[key]+val)){
            if(cart[key] > 0) { cart[key] = Number(cart[key]) + Number(val); } else { cart[key] = Number(val); }
        } else {
            cart[key] = elm.parent().find('input[name="count"]').attr('max');
        }
        syncCart();
    }
}
function removeFromCart(elm) {
    let key = elm.attr('ref');
    delete(cart[key]);
    syncCart();
}
function thousandSeparator(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};
$('.confirmOrder').click(function () {
    if(data.user.bank >= cartTotalPrice) {
        $.post('http://irrp_laptop/submit',JSON.stringify(cart));
    } else { 
        toastr.error("Shoma pol kafi baraye tayid sefaresh nadarid, fekr mikoni mitoni deepweb ro dor bezani?", 'Not enough money!', {timeOut: 8000})
    }
})
$('.closeBtn').click(function () {
    $('#macbook').hide();
    $.post('http://irrp_laptop/close', 1);
});
$('.refreshBtn').click(function () {
    $.post('http://irrp_laptop/refresh', 1);
});