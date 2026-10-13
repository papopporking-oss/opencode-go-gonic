https://opencode.ai/v2/docs/cli/commands/

opencode mini --model "siliconflow/zai-org/GLM-5"

# Run skill
opencode run --model "siliconflow/zai-org/GLM-5" "run skill hello"

# Format json
opencode run --model "siliconflow/zai-org/GLM-5" --format json "run skill hello" | jq

# Action
opencode run --model "siliconflow/zai-org/GLM-5" "Write hello world to ./doc/ai/note.txt"
opencode run --model "siliconflow/zai-org/GLM-5" --file ./doc/ai/note.txt "Read file"
opencode run --model "siliconflow/zai-org/GLM-5" "Read file ./doc/ai/note.txt"

# Action by file
opencode run --model "siliconflow/zai-org/GLM-5" "$(cat ./doc/context/calculator.txt)"

# Select agent and Prompt
opencode run --model "siliconflow/zai-org/GLM-5" --agent build "Fix the failing test"

opencode run --model "siliconflow/zai-org/GLM-5" --help

# Log
opencode run --log-level "all" --print-logs --model "siliconflow/zai-org/GLM-5" "Write hello world 5 line to ./doc/ai/note.txt"

# tee log
opencode run --log-level "all" --print-logs --model "siliconflow/zai-org/GLM-5" "Write hello world 10 line to ./doc/ai/note.txt" | tee -a ./ai.log


# opencode mini
opencode mini --model "siliconflow/zai-org/GLM-5"
opencode mini --model "siliconflow/zai-org/GLM-5" --prompt "Hi"


# session
opencode session list

# plugins
opencode plugin list
opencode plugin check

# service
opencode service start
opencode service restart
opencode service status
opencode service stop
opencode service --help