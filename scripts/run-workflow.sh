#!/bin/bash

# Executes the full development workflow.
# Sequence: Clean -> Format -> Lint -> Test -> Build

set -e # Abort script on any command failure

echo "🚀 Starting Development Workflow..."

echo "🧹 [1/6] Cleaning project..."
./gradlew clean

echo "🎨 [2/6] Applying code formatting (Spotless)..."
./gradlew spotlessApply

echo "🔍 [3/6] Running static analysis (Detekt)..."
./gradlew detekt

echo "🧪 [4/6] Running tests..."
./gradlew allTests

echo "📋 [5/6] Checking API compatibility..."
./gradlew apiCheck

echo "🏗️  [6/6] Building project..."
./gradlew build

echo "✅ Workflow completed successfully! Your code is ready."
