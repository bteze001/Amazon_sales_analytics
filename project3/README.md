# Customer Review & Sentiment Analysis

## Project Overview

A comprehensive Natural Language Processing (NLP) project that analyzes customer reviews from Amazon sales data using sentiment analysis, topic modeling, and aspect-based sentiment extraction.

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Project Structure ](#project-structure)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Analysis Pipeline](#analysis-pipeline)
7. [Results](#results)
8. [Technologies Used ](#technologies-used)
9. [Key Findings](#key-findings)
10. [Future Improveents](#future-improvements)

## Overview

This project applies **Natural Language Processing (NLP)** techniques to analyze customer sentiment from Amazon product reviews. By combining sentiment analysis, topic modeling, and aspect-based extraction, we uncover the drivers of customer satisfaction and identify actionable improvement opportunities.

## Features

* **Text Preprocessing & Cleaning:** Remove noise, URLs, HTML tags, stopwords, and apply lemmatization
* **Sentiment Analysis:** VADER-based sentiment scoring with multi-class classification (Positive, Negative, Neutral)
* **Topic Modeling:** Latent Dirichlet Allocation (LDA) to discover hidden themes in reviews
* **Aspect-Based Sentiment Analysis:** Extract sentiment for specific product aspects (quality, price, performance, ...)
* **Validation:** Compare sentiment predicitions against actual product ratings

## Project Structure

```
project3/
├── results/
│   ├── data/  
│   │   ├── aspect_sentiment_resilts.csv 
│   │ 	├── cleaned_reviews.csv
│   │ 	├── reviews_with_sentiment.csv
│   │ 	├── reviews_with_sentimet(full_file).csv  
│   │   └── reviews_with_topics.csv
│   ├── visualizations/ 
│   ├── findings/ 
├── notebooks/
│   ├── 01_data_loding_exploration.ipynb
│   ├── 02_text_preprocessing.ipynb
│   ├── 03_sentiment_analysis.ipynb
│   ├── 04_topic_modeling.ipynb
│   ├── 05_aspect_based_sentiment.ipynb
│   ├── 06_verify_sentiment_accuracy.ipynb
│   └── 07_insights_summary.ipynb 

```

## Installation

#### Prerequisites

* Python 3.8+
* pip package manager

#### Setup

1. Clone the repository:

   ```
   git clone <repo-link>
   cd project3
   ```
2. Install required packages:

   ```
   pip install pandas numpy matplotlib seaborn
   pip install nltk spacy textblob wordcloud
   pip install scikit-learn pyLDAvis tqdm
   ```
3. Download NLTK data:

   ```
   import nltk
   nltk.download('stopwords)
   nltk.download('punkt)
   nltk.download('wordnet)
   nltk.download(vader_lexicon)
   ```

#### Usage

**Running the Analysis**

Execute the notebooks in sequential order for complete analysis:

1. **Data Loading and Exploration:**

   **Notebook** : `01_data_loading_exploration.ipynb`

   - Load and inspect raw review data
   - Analyze review length distributions
   - Identify top products by review count
   - Generate initial visualizations
2. **Text Preprocessing:**

   **Notebook** : `02_text_preprocessing.ipynb`

   * Clean raw text data by removing URLs, HTML tags, and punctuation
   * Tokenize and lemmatize text
   * Remove stopwords and normalize content
   * Save cleaned reviews for analysis
   * **Output** : `cleaned_reviews.csv`
3. **Sentiment Analysis:**

   **Notebook** : `03_sentiment_analysis.ipynb`

   - Apply VADER sentiment analysis to cleaned reviews
   - Generated compound scores ranginf from -1 (negative) to +1 (positive)
   - Classify reviews as Positive/Neutral/Negative based on threshold values
   - Create comprehensive sentiment distribution visualizations
   - **Output:** `reviews_with_sentiment.csv`, `reviews_with_sentiment(full_file).csv`
4. **Topic Modeling:**

   **Notebook:** : `04_topic_modeling.ipynb`

   - Apply Latent Dirichlet Allocation (LDA) to discover latent topics
   - Extract 5 main topics with top keywords
   - Generate interactive visualizations with pyLDAvis
   - Assign topic labels to each review
   - **Output** : `reviews_with_topics.csv`
5. **Aspect-Based Sentiment:**

   **Notebook** : `05_aspect_based_sentiment.ipynb`

   * Extract sentiment for 7 specific product aspects
   * Generate aspect-level sentiment scores
   * Visualize average sentiment per aspect to identify strengths and weaknesses
   * **Output** : `aspect_sentiment_results.csv`
6. Model Validation

   **Notebook** : `06_verify_sentiment_accuracy.ipynb`

   * Compare VADER sentiment predictions against actual product ratings
   * Generate confusion matrix to visualize model performance
   * Calculate accuracy, precision, recall, and F1-scores
   * Analyze mismatched predictions to understand model limitations
   * **Output** : `confusion_matrix.png `

## Key Findings

#### Sentiment Analysis

1. **Distribution Insights:**
2. **Accuracy Validation:**
3. **Review Length Patterns:**

#### Topic Modeling

- Succesfully identifies 5 distinct themes in customer feedback
- Topic reveal common discussion points include product quality, shipping experience, value for money and customer service.
- Each topic characterized by distinctive keyword patterns
