connect = require 'connect'
request = require 'request'
router = require '../lib/route66'

require 'should'

app = do connect

router.get '/', (req, res) ->
	res.end 'GET /'

router.get '/withMiddleware', (req, res, next) ->
	req.message = 'GET /withMiddleware'
	do next
, (req, res) ->
	res.end req.message
	
router.post '/', (req, res) ->
	res.end 'POST /'

router.notFound (req, res) ->
	res.end "Not found."

app.use router
app.listen 8080

describe 'Route66', ->
	it 'should match "GET /" route', (done) ->
		request
			url: 'http://localhost:8080/'
			method: 'GET'
		, (err, res) ->
			res.body.should.equal 'GET /'
			do done
	
	it 'should match "POST /" route', (done) ->
		request
			url: 'http://localhost:8080/'
			method: 'POST'
		, (err, res) ->
			res.body.should.equal 'POST /'
			do done
	
	it 'should call middleware stack', (done) ->
		request
			url: 'http://localhost:8080/withMiddleware'
			method: 'GET'
		, (err, res) ->
			res.body.should.equal 'GET /withMiddleware'
			do done
	
	it 'should respond with an error', (done) ->
		request
			url: 'http://localhost:8080/error'
			method: 'GET'
		, (err, res) ->
			res.body.should.equal 'Not found.'
			do done