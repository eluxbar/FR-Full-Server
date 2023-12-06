--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

RegisterNetEvent("FR:twitter_getTweets")
AddEventHandler("FR:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("FR:twitter_getFavoriteTweets")
AddEventHandler("FR:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("FR:twitter_newTweets")
AddEventHandler("FR:twitter_newTweets", function(tweet)
  SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
end)

RegisterNetEvent("FR:twitter_updateTweetLikes")
AddEventHandler("FR:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("FR:twitter_setAccount")
AddEventHandler("FR:twitter_setAccount", function(username, password, avatarUrl)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("FR:twitter_createAccount")
AddEventHandler("FR:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("FR:twitter_showError")
AddEventHandler("FR:twitter_showError", function(title, message)
  SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent("FR:twitter_showSuccess")
AddEventHandler("FR:twitter_showSuccess", function(title, message)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent("FR:twitter_setTweetLikes")
AddEventHandler("FR:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)



RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('FR:twitter_login', data.username, data.password)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('FR:twitter_getTweets')
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('FR:twitter_getFavoriteTweets')
end)

RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('FR:twitter_postTweets', data.message)
end)

RegisterNUICallback('twitter_postTweetImg', function(data, cb)
  TriggerServerEvent('FR:twitter_postTweets', data.username or '', data.password or '', data.message)
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('FR:likeTweet',data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
    TriggerServerEvent("FR:setTwitterAvatar", data.avatarUrl)
end)
