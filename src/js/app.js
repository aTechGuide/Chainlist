App = {
  web3Provider: null,
  contracts: {},
  account: 0x0,

  init: function () {

    return App.initWeb3();
  },

  initWeb3: function () {

    console.log("InitWeb3 function called");
    // initialize web3
    if (typeof web3 !== 'undefined') {
      // Resuse provider of web3 object injected by metamask
      App.web3Provider = web3.currentProvider;
    } else {
      // create new provider and plug it into local node
      App.web3Provider = new Web3.providers.HttpProvider("http://localhost:7545");
    }

    web3 = new Web3(App.web3Provider);

    App.displayAccountInfo();

    return App.initContract();
  },

  displayAccountInfo: function () {
    console.log("DisplayAccountInfo function called");
    // Below call will return the account currently selected in metamask
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $('#account').text(account);
        web3.eth.getBalance(account, function (err, balance) {
          if (err === null) {
            $('#accountBalance').text(web3.fromWei(balance, "ether") + " ETH");
          }
        })
      }
    });
  },

  initContract: function () {
    console.log("Init Contract function called");
    $.getJSON('ChainList.json', function (ChainListArtifact) {
      // get Contract artifact file and ise it to instantiate truffle contract abstraction
      App.contracts.ChainList = TruffleContract(ChainListArtifact);
      // set the provide for our contract
      App.contracts.ChainList.setProvider(App.web3Provider);

      // listen to events
      App.listenToEvents();
      // retrieve the article from the contract
      return App.reloadArticles();
    })
  },

  reloadArticles: function () {
    // refersh account information because the balance might have changed
    console.log("Reload Article function called");
    App.displayAccountInfo();

    // retrieve the article placeholder and clear it
    $('#articlesRow').empty();

    App.contracts.ChainList.deployed().then(function (instance) {
      return instance.getArticle();
    }).then(function (article) {
      if (article[0] == 0x0) {
        // no article to display
        return;
      }

      var price = web3.fromWei(article[4], "ether");

      // Retrieve the article template and fill it with data

      // load articlesRow
      var articlesRow = $('#articlesRow');
      var articleTemplate = $('#articleTemplate');

      articleTemplate.find('.panel-title').text(article[2]);
      articleTemplate.find('.article-description').text(article[3]);
      articleTemplate.find('.article-price').text(price);
      articleTemplate.find('.btn-buy').attr('data-value', price);

      var seller = article[0];
      if (seller == App.account) {
        seller = "You";
      }
      articleTemplate.find('.article-seller').text(seller);

      // buyer
      var buyer = article[1];
      if(buyer == App.account) {
        buyer = "You";
      } else if(buyer == 0x0) {
        buyer = "No one yet";
      }
      articleTemplate.find('.article-buyer').text(buyer);

      if(article[0] == App.account || article[1] != 0x0) {
        articleTemplate.find('.btn-buy').hide();
      } else {
        articleTemplate.find('.btn-buy').show();
      }

      articlesRow.append(articleTemplate.html());
    }).catch(function (err) {
      console.log(err.message)
    });
  },

  sellArticle: function () {
    //Retrieve details of article from modal diaglog
    console.log("Sell Article function called");
    var _article_name = $('#article_name').val();
    var _description = $('#article_description').val();
    var _price = web3.toWei(parseFloat($('#article_price').val() || 0), "ether");

    if ((_article_name.trim() == '') || (_price == 0)) {
      // nothing to sell
      return false;
    }

    App.contracts.ChainList.deployed().then(function (instance) {
      return instance.sellArticle(_article_name, _description, _price, {
        from: App.account,
        gas: 500000
      }).then(function (result) {
        // We are doing this thing in event
      }).catch(function (err) {
        console.error(err);
      });
    })
  },

  // listen to events triggered by contract
  listenToEvents: function () {
    console.log("Listen To Events function called");
    App.contracts.ChainList.deployed().then(function (instance) {
      instance.LogSellArticle({}, {}).watch(function (error, event) {
        if(!error) {
          $("#events").append('<li class="list-group-item">' + event.args._name + ' is now for sale </li>')
        } else {
          console.error(error);
        }
        App.reloadArticles();
      });

      instance.LogBuyArticle({}, {}).watch(function (error, event) {
        if(!error) {
          $("#events").append('<li class="list-group-item">' + event.args._buyer + ' bought ' + event.args._name + '</li>')
        } else {
          console.error(error);
        }
        App.reloadArticles();
      });
    });
  },

  buyArticle: function() {
    console.log("Buy Article function called");
    event.preventDefault();

    // retrieve the article price
    var _price = parseFloat($(event.target).data('value'));

    App.contracts.ChainList.deployed().then(function(instance){
      return instance.buyArticle({ from: App.account, value: web3.toWei(_price, "ether"), gas: 500000});
    }).catch(function(error) {
      console.error(error);
    });
  }


};

$(function () {
  $(window).load(function () {
    App.init();
  });
});
