import { microblog } from "../../declarations/microblog";

async function post() {
  let post_button = document.getElementById("post");
  post_button.disabled = true;
  let textarea = document.getElementById("message");
  let text = textarea.value;
  await microblog.post(text);
  post_button.disabled = false;
}

async function load_follows() {
  let follows_section = document.getElementById("follows");
  let follows = await microblog.follows();

  follows = follows.map(follow => {
    follow = follow.toText();
    return follow;
  });

  // remove all the listeners to prevent memory leaks
  let canisterIds = document.querySelectorAll(".canisterId");
  canisterIds.forEach(canisterId => {
    canisterId.replaceWith(canisterId.cloneNode(true));
  });
  

  follows_section.replaceChildren([]);
  follows_section.innerHTML = template("tpl-follows", { follows });

  canisterIds = document.querySelectorAll(".canisterId");
  canisterIds.forEach(canisterId => {
    console.log(canisterId.innerText);
    canisterId.addEventListener("click", () => load_timeline(canisterId.innerText));
  });
}

async function load_timeline(canisterId) {
  let posts_section = document.getElementById("posts");
  let timeline_posts;

  if (canisterId) {
    timeline_posts = await microblog.fetchPosts(canisterId);
  } else {
    timeline_posts = await microblog.timeline(0);
  }

  timeline_posts = timeline_posts.map(post => {
    let time = post.time/1000000n;
    time = time.toString() * 1;
    
    post.time = new Date(time).toLocaleString()
    return post;
  });

  posts_section.replaceChildren([]);
  posts_section.innerHTML = template("tpl-message", { posts: timeline_posts });
}

async function load_posts() {
  let posts_section = document.getElementById("posts");
  let posts = await microblog.posts(0);

  posts = posts.map(post => {
    let time = post.time/1000000n;
    time = time.toString() * 1;
    
    post.time = new Date(time).toLocaleString()
    return post;
  });

  posts_section.replaceChildren([]);
  posts_section.innerHTML = template("tpl-message", { posts });
}

function load() {
  let post_button = document.getElementById("post");
  post_button.addEventListener("click", post);
  
  let title = document.getElementById("title");
  title.addEventListener("click", load_posts);

  load_posts();
  load_follows();
}

window.onload = load;