// Generated by CoffeeScript 1.3.3
(function() {
  var Agent;

  this.Agent = Agent = (function() {

    function Agent(index, width, height, radius, gang) {
      this.index = index;
      this.width = width;
      this.height = height;
      this.radius = radius != null ? radius : 2;
      this.gang = gang != null ? gang : null;
      this.dthrust = 0.75;
      this.dtheta = Math.PI / 16;
      this.mu = 6e-2;
      this.discretization = 30;
      this.nextAction = Math.round(4 * Math.random());
      this.lastAction = -1;
      this.mass = 0.2 * this.radius;
      this.x = this.radius + Math.round(Math.random() * (this.width - 2 * this.radius));
      this.y = this.radius + Math.round(Math.random() * (this.height - 2 * this.radius));
      this.vx = 0;
      this.vy = 0;
      this.gang = !(this.gang != null) ? Math.round(Math.random()) : this.gang;
      this.theta = 2 * Math.PI * Math.random();
      this.thrust = 0;
      this.horzThrust = 0;
      this.vertThrust = 0;
    }

    Agent.prototype.takeNextAction = function() {
      this.takeAction(this.nextAction);
      this.lastAction = this.nextAction;
      return this.nextAction;
    };

    Agent.prototype.takeAction = function(action) {
      if (action == null) {
        action = null;
      }
      if (!(action != null)) {
        action = Math.round(4 * Math.random());
      }
      switch (action) {
        case 1:
          return this.vertThrust = this.dthrust;
        case 2:
          return this.vertThrust = -this.dthrust;
        case 3:
          return this.horzThrust = this.dthrust;
        case 4:
          return this.horzThrust = -this.dthrust;
        case 0:
          this.vertThrust = 0;
          return this.horzThrust = 0;
      }
    };

    Agent.prototype.state = function() {
      return [Math.floor(this.x / this.width * (this.discretization - 1)), Math.floor(this.y / this.height * (this.discretization - 1)), this.gang];
    };

    Agent.prototype.reward = function() {
      var jetTarget, pos, sharkTarget;
      pos = {
        x: this.x,
        y: this.y
      };
      jetTarget = {
        x: this.width * 0.75,
        y: this.height * 0.5
      };
      sharkTarget = {
        x: this.width * 0.25,
        y: this.height * 0.5
      };
      if (distance(pos, sharkTarget) < 100) {
        switch (this.gang) {
          case 0:
            return -100;
          case 1:
            return 100;
        }
      } else if (distance(pos, jetTarget) < 100) {
        switch (this.gang) {
          case 0:
            return 100;
          case 1:
            return -100;
        }
      } else {
        return -1;
      }
    };

    Agent.prototype.update = function(tree) {
      this.vx += this.horzThrust;
      this.vy += this.vertThrust;
      this.vx += -1 * sgn(this.vx) * this.mu * this.vx * this.vx;
      this.vy += -1 * sgn(this.vy) * this.mu * this.vy * this.vy;
      this.x += this.vx;
      this.y += this.vy;
      if (this.x < this.radius) {
        this.x = this.radius;
        this.vx = Math.abs(this.vx);
      } else if (this.x > this.width - this.radius) {
        this.x = this.width - this.radius;
        this.vx = -1 * Math.abs(this.vx);
      }
      if (this.y < this.radius) {
        this.y = this.radius;
        this.vy = Math.abs(this.vy);
      } else if (this.y > this.height - this.radius) {
        this.y = this.height - this.radius;
        this.vy = -1 * Math.abs(this.vy);
      }
      return this.state();
    };

    return Agent;

  })();

}).call(this);
