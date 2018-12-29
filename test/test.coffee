mongo=null

getRandomInt=(min, max)->
  min = Math.ceil(min)
  max = Math.floor(max)
  Math.floor(Math.random() * (max - min)) + min

o=
  url:"mongodb://mongo:27017/"
  db:"test"
  collection:"tests"
  key:
    name:"test100"
  data:
    name:"test100"
    value:getRandomInt(100,999)

o2=
  url:"mongodb://mongo:27017/"
  db:"test"
  collection:"tests"
  key:
    name:"test100"
  data:
    name:"test101"
    value:getRandomInt(100,999)

o3=
  url:"mongodb://mongo:27017/"
  db:"test"
  collection:"tests"
  key:
    name:"test101"
  data:{}

after (done)->
  mongo.delete o,(e1,r)->
    mongo.delete o2,(e2,r)->
      mongo.delete o3,(e3,r)->
        done e1||e2||e3

it "should be able to load",(done)->
  mongo=require "../../gqmongodb"
  done()

it "should be able to create",(done)->
  mongo.create o,(e,r)->
    console.dir r
    done e

it "should not be able to create same item twice",(done)->
  mongo.create o,(e,r)->
    console.log r
    done !(r=[])

it "should be able to find",(done)->
  mongo.find o,(e,r)->
    console.dir r
    done e

it "should be able to upsert",(done)->
  mongo.upsert o,(e,r)->
    console.dir r
    done e

it "should be able to disable",(done)->
  mongo.disable o,(e,r)->
    console.dir r
    done e

it "should be able to delete",(done)->
  mongo.delete o,(e,r)->
    console.dir r
    done e

