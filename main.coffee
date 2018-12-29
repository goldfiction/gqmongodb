mongodb = require("mongodb").MongoClient
ObjectID = require('mongodb').ObjectID

that=this

@newID=()->
  new ObjectID()

@doconnect=(o,cb)->
  mongodb.connect o.url,{ useNewUrlParser: true },(e, client)->
    db=client.db(o.db)
    collection=db.collection(o.collection)
    o.clientObj=client
    o.dbObj=db
    o.collectionObj=collection
    cb(e,o)

@find=(o,cb)->
  @doconnect o,(e,o)->
    collection=o.collectionObj
    collection.find(o.key).toArray (e,docs)->
      cb(e,docs)

@create=(o,cb)->
  @doconnect o,(e,o)->
    collection=o.collectionObj
    o.data.updateTime=new Date()
    o.data.createTime=new Date()
    o.data._id=new ObjectID()
    o.data.enabled=true
    that.find o,(e,docs)->
      if docs.length==0
        collection.insertOne o.data,(e,r)->
          cb e,r.ops
      else
        cb null,[]
      o.clientObj.close()

@upsert=(o,cb)->
  @doconnect o,(e,o)->
    collection=o.collectionObj
    o.data.updateTime=new Date()
    delete o.data._id
    collection.updateMany o.key,
      $set:o.data
    ,
      upsert:true
    ,(e,r)->
      collection.find(o.data).toArray cb
      o.clientObj.close()

@disable=(o,cb)->
  o.data={}
  o.data.enabled=false
  o.data.updateTime=new Date()
  @upsert(o,cb)

@delete=(o,cb)->
  @doconnect o,(e,o)->
    collection=o.collectionObj
    that.find o,(e,docs)->
      collection.deleteMany o.key,(e,r)->
        result=r.result
        result.docs=docs
        cb e,result
        o.clientObj.close()
