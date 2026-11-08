import rclpy
from rclpy.node import Node
from tf2_ros import TransformBroadcaster
from geometry_msgs.msg import TransformStamped
import pkg_resources
from transforms3d.euler import euler2quat

import numpy as np

class MetaflyTfPublisher(Node):

    def __init__(self):
        super().__init__('metafly_tf_publisher')
        self.tf_broadcaster = TransformBroadcaster(self)
        self.timer = self.create_timer(0.1, self.broadcast_tf)
        self.elapsed_time = 0.0
        
        # read the CSV file
        csv_file = pkg_resources.resource_filename('metafly_tf_pub', '../resource/mocap_data.csv')
        data = np.genfromtxt(csv_file, delimiter=',', skip_header=1)
        
        # Extract X, Y, Z, Roll, Pitch, Yaw data
        self.x = data[:,1]
        self.y = data[:,2]
        self.z = data[:,3]
        
        # convert from degrees to radians
        self.roll = np.deg2rad(data[:,4])
        self.pitch = np.deg2rad(data[:,5])
        self.yaw = np.deg2rad(data[:,6])

        # (optional): subtract initial values so that metafly starts above the world origin
        # self.x -= self.x[0]
        # self.y -= self.y[0]
        
        # index (for looping through the data)
        self.i = 0
        self.data_length = len(self.x)
    

    def broadcast_tf(self):
        tf = TransformStamped()

        # Header
        tf.header.stamp = self.get_clock().now().to_msg()
        tf.header.frame_id = 'world'  # parent frame
        tf.child_frame_id = 'base_link'  # child frame

        # Position
        tf.transform.translation.x = self.x[self.i]
        tf.transform.translation.y = self.y[self.i]
        tf.transform.translation.z = self.z[self.i]

        # Orientation (convert Euler to Quaternion with transforms3d.euler module)
        # x-axis is pitch
        # y-axis is roll
        # z-axis is yaw (z up)
        q = euler2quat(self.pitch[self.i], self.roll[self.i], self.yaw[self.i])
        tf.transform.rotation.w = q[0]
        tf.transform.rotation.x = q[1]
        tf.transform.rotation.y = q[2]
        tf.transform.rotation.z = q[3]

        # Broadcast the transform
        self.tf_broadcaster.sendTransform(tf)
        
        # update the index
        self.i += 1
        self.i %= self.data_length

def main(args=None):
    rclpy.init(args=args)
    node = MetaflyTfPublisher()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
