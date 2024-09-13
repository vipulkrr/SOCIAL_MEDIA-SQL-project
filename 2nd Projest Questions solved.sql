# know all COLUMN_NAME of social_media by each and every TABLE_NAME.
SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'social_media';

# Q.1 write a query to find all posts made by users in specific locations such as 'Agra',"Maharashtra', and 'West Bengal'

USE social_media;

SELECT * FROM post WHERE location IN ('Agra', 'Maharashtra', 'West Bengal');

# Here we find the total number(COUNT) of all these three locations( 'Agra', 'Maharashtra', and 'West Bengal' )
SELECT COUNT(*) FROM post WHERE location IN ('Agra', 'Maharashtra', 'West Bengal');

# Here we find out total number of specific locations.
SELECT location, COUNT(*) AS total_posts  FROM post WHERE location IN ('Agra', 'Maharashtra', 'West Bengal') GROUP BY location;

# Q.2 Determine the most followed hashtags.alter
# write a query to list the top 5 most-followed hashtags on the platform.
# Hint: join relevant tables to calculate the total follows for each hashtag.alter

SELECT hashtag_name , COUNT(hf.user_id) AS total_follows 
FROM hashtags h
JOIN hashtag_follow hf ON h.hashtag_id = hf.hashtag_id
GROUP BY hashtag_name
ORDER BY total_follows DESC
LIMIT 5;

# Q.3 Find the most used hashtags
# Identify the top 10 most-used hashtags in posts.
# Hint: Count how many times each hashtag appears in posts.

SELECT h.hashtag_name as hashtag_name, COUNT(hf.user_id) AS usage_count
FROM hashtags h
JOIN hashtag_follow hf ON h.hashtag_id = hf.hashtag_id
GROUP BY hashtag_name
ORDER BY usage_count DESC
LIMIT 10;

# Q.4 Identify the most inactive user.
# write a quesry to find users who have never made any posts on the platform.
# Hint: Use a subquery to identify these users.

SELECT u.user_id, u.username as inactive_username
FROM users u
LEFT JOIN post p ON u.user_id = p.user_id
WHERE p.post_id IS NULL;

# Q.5 Identify the posts with the most likes.
# Write a query to find the posts that have received the highest number of likes.
# Hint: Count the number of likes for each post.

SELECT p.post_id, p.caption, p.created_at, COUNT(pl.user_id) AS total_likes
FROM post p
JOIN post_likes pl ON p.post_id = pl.post_id
GROUP BY p.post_id, p.caption
ORDER BY total_likes DESC
LIMIT 5;
#                          OR
# Following are the posts along with username, post_id, caption, time(created_at), and total_likes
SELECT u.username, p.post_id, p.caption, p.created_at, COUNT(pl.user_id) AS total_likes
FROM post p
JOIN users u ON u.user_id = p.user_id
JOIN post_likes pl ON p.post_id = pl.post_id
GROUP BY p.post_id, p.caption
ORDER BY total_likes DESC
LIMIT 5;

# Q.6 Calculate Average Posts per user.
# write a query to determine the average number of posts made by users.
# Hint: Consider dividing the total number of posts by the number of unique users.
SELECT COUNT(p.user_id) / COUNT(DISTINCT u.user_id) AS avg_posts_per_user
FROM  users u
LEFT JOIN  post p ON u.user_id = p.user_id;

# OR this my query for finding top 5 users avg by the name 
# average post user wise along with the name of user and user_id

SELECT u.user_id, u.username,
 COUNT(p.user_id) / COUNT(DISTINCT u.user_id) AS top_avg_user_post
FROM  users u
LEFT JOIN  post p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
ORDER BY top_avg_user_post DESC
LIMIT 5;

# Q.7 track the number of logins per user.
# write a query to track the total number of logins made by each user.
# Hint: join user and login tables.
SELECT u.user_id, u.username, COUNT(l.login_time) AS total_logins
FROM users u
JOIN login l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username
ORDER BY total_logins DESC;

# Q.8 identify a user who liked every single post
# write a query to find any user who has liked every post on the platform.
# Hint: Compare the number of posts with the number of likes  by this user.
SELECT u.user_id, u.username
FROM users u
JOIN post_likes pl ON u.user_id = pl.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT pl.post_id) = (SELECT COUNT(*) FROM post);
# this question has answer NULL because not had any single user liked every single post in social_media.

# Q.9 find users who have never commented
# write a query to find users who have never commented on any post.
# Hint: Use a subquery to execlude users who have commented.
SELECT u.user_id, u.username
FROM users u
WHERE u.user_id NOT IN (SELECT DISTINCT c.user_id FROM comments c);

# Q.10 Identify a user who commented on every post.
# write a query to find any user who has commented on every post on the platform.alter
# Hint: compare the number of posts with the number of comments by this user.
SELECT u.user_id, u.username
FROM users u
JOIN comments c ON u.user_id = c.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT c.post_id) = (SELECT COUNT(*) FROM post);

# Q.11 identify users not followed by anyone.
#  write a query to find users who are not followed by any other users.
# Hint: use the follows table to find users who have no followers.

SELECT u.user_id, u.username
FROM users u
LEFT JOIN follows f ON u.user_id = f.followee_id
WHERE f.follower_id IS NULL;
# LEFT JOIN follows f ON u.user_id = f.followee_id: Performs a LEFT JOIN to include all users, even if they are not followed by anyone.The followee_id represents users being followed.
# WHERE f.follower_id IS NULL: Filters out users who have no entries in the follows table as a followee, meaning they are not followed by any other users.

# Q.12 identify users who are not following anyone.
# write a query to find users who are not following anyone.
# Hint: use the follows table to identify users who are not following others.
 
SELECT u.user_id, u.username
FROM  users u
LEFT JOIN follows f ON u.user_id = f.follower_id
WHERE f.followee_id IS NULL; 
 
# LEFT JOIN follows f ON u.user_id = f.follower_id: Joins the users table with the follows table to include all users, even those who are not following anyone (where follower_id is the user who follows someone).
# WHERE f.followee_id IS NULL: Filters the result to return only users who have no entries in the follows table as a follower, meaning they are not following anyone.

# Q.13 find users who have posted more than 5 times.
# write a query to find users who have made more than five posts.
# Hint: group the post by user and filter the results based on the number of posts.
SELECT u.user_id, u.username, COUNT(p.post_id) AS total_posts
FROM users u
JOIN post p ON u.user_id = p.post_id
GROUP BY u.user_id, u.username
HAVING COUNT(p.post_id) > 5;
# JOIN post p ON u.user_id = p.post_id: Joins the users table with the posts table to find the number of posts each user has made.
# GROUP BY u.user_id, u.username: Groups the result by user ID and name to calculate the number of posts per user.
# HAVING COUNT(p.post_id) > 5: Filters the results to include only users who have made more than five posts.

# Q.14 identify users with more than 40 followers.
# write a query to find users who have more than 40 followers.
# Hint: group the followers and filter the result for those with a high follower count.
SELECT u.user_id, u.username, COUNT(f.follower_id) AS follower_count
FROM users u
JOIN follows f ON u.user_id = f.followee_id
GROUP BY u.user_id, u.username
HAVING COUNT(f.follower_id) > 40;
#               OR  
SELECT u.user_id, u.username, COUNT(f.follower_id) AS follower_count
FROM users u
JOIN follows f ON u.user_id = f.followee_id
GROUP BY u.user_id, u.username
HAVING COUNT(f.follower_id) > 40
ORDER BY follower_count DESC;
# here dispalying the users in descending order who have more than 40 followers

# JOIN follows f ON u.id = f.followee_id: Joins the users table with the follows table to find the number of followers each user has.
# GROUP BY u.id, u.name: Groups the result by user ID and name so that the follower count can be calculated for each user.
# HAVING COUNT(f.follower_id) > 40: Filters the result to include only users who have more than 40 followers.

# Q.15 Search for specific words in comments.
# write a query to find comments containing specific words like "good" or "beautiful".
# Hint: use regular expressions to search for these words.
SELECT comment_id, user_id, post_id, comment_text
FROM comments
WHERE comment_text REGEXP '\\b(good|beautiful)\\b';
#                        OR
SELECT comment_id, user_id, post_id, comment_text
FROM comments
WHERE comment_text LIKE '%good%' OR comment_text LIKE '%beautiful%';


# REGEXP '\\b(good|beautiful)\\b': The REGEXP operator searches for comments that contain the words "good" or "beautiful". The \\b is a word boundary that ensures the words are matched as whole words and not as part of other words (e.g., "goodbye" won't be matched).
# The regular expression (good|beautiful) searches for either "good" or "beautiful" in the comment_text.

# Q.16 identify the longest captions in posts.
# write a query to find the posts with the longest captions.
# Hint: calculate the length of each caption and sort them to find the top 5 longest ones.
SELECT p.post_id, p.caption, p.location, LENGTH(caption) AS caption_length
FROM post p
ORDER BY caption_length DESC
LIMIT 5;
#    this is second query for getting the name of longest caption users with his location.
SELECT p.post_id, p.caption, u.username, p.location, LENGTH(caption) AS caption_length
FROM post p
JOIN users u ON u.user_id = p.user_id
ORDER BY caption_length DESC
LIMIT 10;


















 


































