import React, { useState, useEffect, useMemo, useCallback } from 'react';

// Sample React component for testing AI code review
interface UserProps {
  id: number;
  name: string;
  email?: string;  // Optional email field
}

interface UserCardProps extends UserProps {}

const UserCard: React.FC<UserCardProps> = ({ id, name, email }) => {
  const [isLoading, setIsLoading] = useState(false);
  const [userData, setUserData] = useState<UserProps | null>(null);
  const [error, setError] = useState<string | null>(null);

  // FIXED: Added proper error handling with user feedback
  useEffect(() => {
    if (!id || typeof id !== 'number') {
      setError('Invalid user ID provided');
      return;
    }

    const fetchUserData = async () => {
      setIsLoading(true);
      setError(null); // Clear previous errors

      try {
        const response = await fetch(`/api/users/${id}`);

        if (!response.ok) {
          throw new Error(`Failed to fetch user: ${response.status} ${response.statusText}`);
        }

        const data = await response.json();

        // Validate response data
        if (!data || typeof data !== 'object') {
          throw new Error('Invalid user data received');
        }

        setUserData(data);
      } catch (error) {
        console.error('Failed to fetch user data:', error);
        // FIXED: Show user-friendly error message
        setError('Unable to load user data. Please try again.');
      } finally {
        setIsLoading(false);
      }
    };

    fetchUserData();
  }, [id]);

  // FIXED: Added proper validation and immutable state updates
  const handleUserUpdate = useCallback((updatedUser: UserProps) => {
    // Input validation
    if (!updatedUser || typeof updatedUser !== 'object') {
      setError('Invalid user data for update');
      return;
    }

    if (!updatedUser.name || typeof updatedUser.name !== 'string') {
      setError('User name is required');
      return;
    }

    // FIXED: Immutable state update
    setUserData(prevData => ({
      ...prevData,
      ...updatedUser,
      id // Preserve original ID
    }));

    setError(null); // Clear any previous errors
  }, [id]);

  // PERFORMANCE: Memoize expensive date calculation
  const lastUpdated = useMemo(() => {
    return new Date().toLocaleDateString();
  }, [userData]); // Only recalculate when userData changes

  if (error) {
    return (
      <div className="user-card error" role="alert" aria-live="polite">
        <div className="error-message">
          <span className="error-icon" aria-hidden="true">⚠️</span>
          {error}
          <button
            onClick={() => setError(null)}
            className="error-dismiss"
            aria-label="Dismiss error message"
          >
            ×
          </button>
        </div>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="user-card loading" aria-live="polite">
        <div className="loading-content">
          <span className="loading-spinner" aria-hidden="true">⏳</span>
          <span>Loading user data...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="user-card" role="article">
      <header>
        <h3 id={`user-${id}-name`}>{name}</h3>
        {email && (
          <p className="email" aria-describedby={`user-${id}-name`}>
            <span className="sr-only">Email address:</span>
            {email}
          </p>
        )}
      </header>

      {/* PERFORMANCE: Memoized expensive calculation */}
      <div className="stats" role="complementary">
        {userData && (
          <span aria-label={`Last updated on ${lastUpdated}`}>
            Last updated: {lastUpdated}
          </span>
        )}
      </div>

      {/* ACCESSIBILITY: Added proper aria-label and keyboard support */}
      <button
        onClick={() => handleUserUpdate({ id, name: name + ' (Updated)', email })}
        className="update-btn"
        aria-label={`Update user information for ${name}`}
        aria-describedby={`user-${id}-name`}
        type="button"
      >
        <span aria-hidden="true">🔄</span>
        Update User
      </button>
    </div>
  );
};

export default UserCard;
