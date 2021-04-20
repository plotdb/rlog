require! <[date-fns]>

setInterval (->
  date = date-fns.format(new Date!, 'hh:mm:ss')
  console.log "#date / #{Date.now!}"
), 1000
