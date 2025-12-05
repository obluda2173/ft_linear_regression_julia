CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -Werror

SRC_DIR := src/cpp
SRC_PY := src/python
DATA_DIR := data
BUILD_DIR := bin

TRAIN_SRC := $(SRC_DIR)/train.cpp
PREDICT_SRC := $(SRC_DIR)/predict.cpp
PRECISION_SRC := $(SRC_DIR)/precision.cpp
UTILS_SRC := $(SRC_DIR)/utils.cpp
BGD_SRC := $(SRC_DIR)/bgd.cpp
GRAPH_SRC := $(SRC_PY)/graph.py

TRAIN_BIN := $(BUILD_DIR)/train
PREDICT_BIN := $(BUILD_DIR)/predict
PRECISION_BIN := $(BUILD_DIR)/precision

RED   := \033[1;31m
GREEN := \033[1;32m
BLUE  := \033[1;34m
RESET := \033[0m

all: $(TRAIN_BIN) $(PREDICT_BIN) $(PRECISION_BIN)
	@echo "$(GREEN)✔ Build complete$(RESET)"

re: clean all

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(TRAIN_BIN): $(TRAIN_SRC) $(BGD_SRC) $(UTILS_SRC) | $(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "$(BLUE)✔ train built$(RESET)"

$(PREDICT_BIN): $(PREDICT_SRC) $(UTILS_SRC) $(BGD_SRC) | $(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "$(BLUE)✔ predict built$(RESET)"

$(PRECISION_BIN): $(PRECISION_SRC) $(BGD_SRC) $(UTILS_SRC) | $(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "$(BLUE)✔ precision built$(RESET)"

run: train predict

train: $(TRAIN_BIN)
	@cd $(SRC_DIR) && ../../$(TRAIN_BIN)

predict: $(PREDICT_BIN)
	@cd $(SRC_DIR) && ../../$(PREDICT_BIN)

graph: $(GRAPH_SRC) train
	@cd $(SRC_PY) && python3 graph.py
	@echo "$(BLUE)✔ Graph generated$(RESET)"

precision: $(PRECISION_BIN) train
	@cd $(SRC_DIR) && ../../$(PRECISION_BIN)

%.o: %.cpp
	@$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	@rm -fr $(BUILD_DIR) $(DATA_DIR)/model.json $(DATA_DIR)/loss.csv
	@echo "$(RED)✔ Cleaned$(RESET)"

.PHONY: all clean train predict graph precision
