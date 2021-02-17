# Environment detection
isDev = process.env.NODE_ENV == 'development'
isGenerating = process.env.npm_lifecycle_event == 'generate'

# Export API
module.exports = {
	isDev, isGenerating
}
