JULIA := julia
JFLAGS := --project=.

SRC_DIR := src
DATA_DIR := data
MODEL_DIR := models

MODEL_FILE := $(MODEL_DIR)/thetas.csv

TRAIN_SRC := $(SRC_DIR)/train.jl
PREDICT_SRC := $(SRC_DIR)/predict.jl
METRICS_SRC := $(SRC_DIR)/metrics.jl
PLOTS_SRC := $(SRC_DIR)/plots.jl

RED   := \033[1;31m
GREEN := \033[1;32m
BLUE  := \033[1;34m
RESET := \033[0m

all: train predict metrics
	@echo "$(GREEN)✔ All tasks completed$(RESET)"

re: clean all

setup:
	@mkdir -p models
	@[ -s ./models/thetas.csv ] || echo "theta_0,theta_1,mu,sigma\n0,0,0,1" > ./models/thetas.csv
	@$(JULIA) $(JFLAGS) -e 'using Pkg; Pkg.instantiate()'
	@echo "$(GREEN)✔ Dependencies installed$(RESET)"

train: setup
	@cd $(SRC_DIR) && $(JULIA) $(JFLAGS) train.jl
	@echo "$(BLUE)✔ Model trained$(RESET)"

predict: setup
	@cd $(SRC_DIR) && $(JULIA) $(JFLAGS) predict.jl

metrics: setup
	@cd $(SRC_DIR) && $(JULIA) $(JFLAGS) metrics.jl

graph: setup
	@mkdir -p plots
	@cd $(SRC_DIR) && $(JULIA) $(JFLAGS) plots.jl
	@echo "$(BLUE)✔ Graph generated$(RESET)"

clean:
	@rm -f $(MODEL_FILE)
	@echo "$(RED)✔ Cleaned$(RESET)"

.PHONY: all re setup train predict precision graph clean
