#!/usr/bin/env python3
"""
API client for testing AI code review system
Demonstrates Python code that can be reviewed
"""

import requests
import json
import logging
from typing import Dict, List, Optional
from dataclasses import dataclass
import asyncio
import aiohttp
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

@dataclass
class ReviewRequest:
    """Data class for review requests"""
    files: List[str]
    comments: Dict[str, str]
    exclude_patterns: Optional[List[str]] = None

class AIReviewClient:
    """Client for interacting with AI Review API"""

    def __init__(self, base_url: str = "http://localhost:3002", timeout: int = 30):
        self.base_url = base_url
        self.timeout = timeout
        self.session = requests.Session()

        # Add retry strategy for resilience
        retry_strategy = Retry(
            total=3,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("http://", adapter)
        self.session.mount("https://", adapter)

        # Set default timeout
        self.session.timeout = timeout

        # Configure logging
        self.logger = logging.getLogger(__name__)

    def get_health_status(self) -> Dict:
        """
        Get repository health status
        Returns: Health status dictionary
        """
        try:
            response = self.session.get(f"{self.base_url}/api/health")
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            # FIXED: Proper logging without sensitive data exposure
            self.logger.error(f"Health check failed: {type(e).__name__}")
            return {"status": "error", "message": "Health check failed"}
        except Exception as e:
            self.logger.error(f"Unexpected error during health check: {type(e).__name__}")
            return {"status": "error", "message": "Service unavailable"}

    def get_staged_files(self) -> List[str]:
        """Get list of staged files for review"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/staged-files",
                timeout=self.timeout
            )
            response.raise_for_status()

            data = response.json()
            files = data.get("files", [])

            # Validate response structure
            if not isinstance(files, list):
                self.logger.warning("Invalid response format: files is not a list")
                return []

            return [f for f in files if isinstance(f, str)]

        except requests.RequestException as e:
            self.logger.error(f"Failed to get staged files: {type(e).__name__}")
            return []
        except (ValueError, KeyError) as e:
            self.logger.error(f"Invalid response format: {type(e).__name__}")
            return []

    def export_for_ai_review(self, request: ReviewRequest) -> bool:
        """
        Export files for AI review

        Args:
            request: Review request data

        Returns:
            Success status
        """
        payload = {
            "comments": request.comments,
            "lineComments": {},  # ENHANCEMENT: Add support for line comments
            "excludedFiles": request.exclude_patterns or []
        }

        # FIXED: Validate payload before sending
        if not self._validate_export_payload(payload):
            self.logger.error("Invalid export payload")
            return False

        try:
            response = self.session.post(
                f"{self.base_url}/api/export-for-ai",
                json=payload,
                headers={"Content-Type": "application/json"},
                timeout=self.timeout
            )
            response.raise_for_status()

            result = response.json()
            files_processed = result.get('filesProcessed', 0)
            self.logger.info(f"Review exported successfully: {files_processed} files processed")
            print(f"✅ Review exported: {files_processed} files processed")
            return True

        except requests.RequestException as e:
            # SECURITY: Don't expose internal error details
            self.logger.error(f"Export request failed: {type(e).__name__}")
            print(f"❌ Export failed: Network error")
            return False
        except (ValueError, KeyError) as e:
            self.logger.error(f"Invalid export response: {type(e).__name__}")
            print(f"❌ Export failed: Invalid response")
            return False

    def _validate_export_payload(self, payload: Dict) -> bool:
        """Validate export payload for security"""
        if not isinstance(payload, dict):
            return False

        # Validate comments
        comments = payload.get('comments', {})
        if not isinstance(comments, dict):
            return False

        # Validate excluded files
        excluded = payload.get('excludedFiles', [])
        if not isinstance(excluded, list) or not all(isinstance(f, str) for f in excluded):
            return False

        return True

async def async_health_check(url: str, timeout: int = 10) -> Dict:
    """Async version of health check - PERFORMANCE improvement"""
    try:
        timeout_config = aiohttp.ClientTimeout(total=timeout)
        async with aiohttp.ClientSession(timeout=timeout_config) as session:
            async with session.get(f"{url}/api/health") as response:
                if response.status == 200:
                    return await response.json()
                else:
                    return {"status": "error", "message": "Service unavailable"}
    except asyncio.TimeoutError:
        return {"status": "error", "message": "Request timeout"}
    except Exception as e:
        logging.error(f"Async health check failed: {type(e).__name__}")
        return {"status": "error", "message": "Service unavailable"}

def main():
    """Main function demonstrating client usage"""
    client = AIReviewClient()

    # Check server health
    health = client.get_health_status()
    print(f"Server status: {health.get('status', 'unknown')}")

    # Get staged files
    files = client.get_staged_files()
    print(f"Found {len(files)} staged files")

    if files:
        # Create review request
        request = ReviewRequest(
            files=files,
            comments={
                "test/api-client.py": "🐛 Multiple issues found: missing error handling, security concerns, and performance opportunities"
            },
            exclude_patterns=["*.log", "node_modules/*"]
        )

        # Export for review
        success = client.export_for_ai_review(request)
        if success:
            print("🎉 AI review export completed successfully!")
        else:
            print("❌ AI review export failed")

if __name__ == "__main__":
    # ENHANCEMENT: Add argument parser for CLI usage
    main()
